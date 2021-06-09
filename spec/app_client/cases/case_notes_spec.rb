# frozen_string_literal: true

require_relative '../cases/pages/case'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'

describe '[Cases]', :app_client, :cases do
  let(:case_detail_page) { Case.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as a Referrals Admin user]') do
    before do
      @contact = Setup::Data.create_harvard_client_with_consent

      @case = Setup::Data.create_service_case_for_harvard(contact_id: @contact.contact_id)

      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
    end

    it 'updates a case with a Service Provided type interaction', :uuqa_155 do
      case_detail_page.go_to_open_case_with_id(case_id: @case.id, contact_id: @contact.contact_id)
      expect(case_detail_page.page_displayed?).to be_truthy

      case_detail_page.open_notes_section
      expect(case_detail_page.notes_section_displayed?).to be_truthy
      service_provided_note = {
        service: Faker::Lorem.word,
        amount: Faker::Number.number(digits: 3),
        content: Faker::Lorem.sentence(word_count: 5)
      }
      case_detail_page.add_service_provided_note(service_provided_note)

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::SERVICE_SUCCESSFULLY_LOGGED)
    end
  end
end
