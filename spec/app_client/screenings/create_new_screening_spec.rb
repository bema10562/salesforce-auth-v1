# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative '../clients/pages/search_client_page'
require_relative '../clients/pages/confirm_client_page'
require_relative '../clients/pages/add_client_page'
require_relative './pages/new_screening_page'
require_relative '../consent/pages/consent_modal'
require_relative '../facesheet/pages/facesheet_header'
require_relative './pages/screening_page'

describe '[Screenings - Create New Screening]', :screenings, :app_client, :create_screenings do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:create_menu) {RightNav::CreateMenu.new(@driver)}
  let(:search_client_page) { SearchClient.new(@driver) }
  let(:confirm_client_page) { ConfirmClient.new(@driver) }
  let(:add_client_page) { AddClient.new(@driver) }
  let(:new_screening_page) { NewScreeningPage.new(@driver) }
  let(:consent_modal) { ConsentModal.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:screening_page) { ScreeningPage.new(@driver) }

  context('[as a user with Screening Role]') do
    before {
      log_in_as(Login::SCREENINGS_USER_MULTI_NETWORK)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'user can create a screening with no referral needs for a new client', :uuqa_1770 do
      fname = Faker::Name.first_name
      lname = Faker::Name.last_name
      dob = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')
      create_menu.start_new_screening
      expect(search_client_page.page_displayed?).to be_truthy
      search_client_page.search_client(fname: fname, lname: lname, dob: dob)

      # No clients should display they should be send directly to pre-filled form
      # But in the event of Faker returning the same data twice, we can create a new client
      confirm_client_page.click_create_new_client if confirm_client_page.page_displayed?

      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(fname: fname, lname: lname, dob: dob)).to be_truthy
      add_client_page.save_client
      expect(new_screening_page.page_displayed?).to be_truthy
      new_screening_page.complete_screening_with_no_referral_needs
      consent_modal.add_consent_by_document_upload
      expect(facesheet_header.facesheet_name).to eq "#{fname} #{lname}"
      expect(screening_page.page_displayed?).to be_truthy
      expect(screening_page.no_needs_displayed?).to be_truthy
    end
  end
end