# frozen_string_literal: true

require_relative '../cases/pages/case'
require_relative '../cases/pages/case_review'
require_relative '../cases/pages/create_case'
require_relative '../cases/pages/open_cases_dashboard'
require_relative '../facesheet/pages/facesheet_cases_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'

describe '[cases]', :app_client, :cases do
  let(:case_detail_page) { Case.new(@driver) }
  let(:create_case) { CreateCase.new(@driver) }
  let(:facesheet_cases_page) { FacesheetCases.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:open_cases_dashboard) { OpenCasesDashboard.new(@driver) }
  let(:case_review) { CaseReview.new(@driver) }

  context('[as cc user]') do
    before do
      @contact = Setup::Data.random_existing_harvard_client

      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      cases_path = facesheet_header.path(contact_id: @contact.contact_id, tab: 'cases')
      facesheet_header.authenticate_and_navigate_to(token: @auth_token, path: cases_path)
      expect(facesheet_cases_page.page_displayed?).to be_truthy
    end

    it 'creates case via facesheet with custom OON provider input', :uuqa_645, :smoke do
      facesheet_cases_page.create_new_case
      expect(create_case.page_displayed?).to be_truthy
      expect(create_case.is_oon_program_auto_selected?).to be_truthy

      description = Faker::Lorem.sentence(word_count: 5)
      provider = Faker::Lorem.sentence(word_count: 2)
      submitted_case_selections = create_case.create_oon_case_with_first_options_and_custom_provider(
        description: description,
        provider: provider
      )
      expect(case_review.page_displayed?).to be_truthy

      case_review_selections = {
        service_type: case_review.service_type,
        org: case_review.referred_to,
        primary_worker: case_review.primary_worker
      }
      expect(case_review_selections).to eq submitted_case_selections
      expect(case_review.notes).to eq description

      case_review.click_submit_button

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::CASE_CREATED)
      expect(open_cases_dashboard.open_cases_table_displayed?).to be_truthy

      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id, tab: 'Cases')
      facesheet_cases_page.click_first_case
      expect(case_detail_page.page_displayed?).to be_truthy

      case_detail_selections = {
        service_type: case_detail_page.service_type,
        org: case_detail_page.referred_to,
        primary_worker: case_detail_page.primary_worker,
      }
      expect(case_detail_selections).to eq submitted_case_selections
      expect(case_detail_page.notes).to eq description
    end
  end
end
