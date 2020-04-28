require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/left_nav'
require_relative '../clients/pages/clients_page'
require_relative './pages/facesheet_overview_page'

describe '[Facesheet]', :app_client, :facesheet do
  include Login

  let(:login_email) {LoginEmail.new(@driver) }
  let(:login_password) {LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:clients_page) { ClientsPage.new(@driver) }
  let(:overview_page) { Overview.new(@driver)}

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)
      left_nav.go_to_clients
      expect(clients_page.page_displayed?).to be_truthy
      clients_page.go_to_facesheet_second_authorized_client
    } 

    it 'Add Phone Interaction Note', :uuqa_157 do
      interaction_note = { :type => 'Phone Call', :duration => '15m', :content => Faker::Lorem.sentence(word_count:5) }
      overview_page.add_interaction(interaction_note)
      created_note = overview_page.first_note_in_timeline
      expect(created_note).to eql(interaction_note)
    end

    it 'Add Email Interaction Note', :uuqa_157 do
      interaction_note = { :type => 'Email', :duration => 'N/A', :content => Faker::Lorem.sentence(word_count:5) }
      overview_page.add_interaction(interaction_note)
      created_note = overview_page.first_note_in_timeline
      expect(created_note).to eql(interaction_note)
    end

    it 'Add In-Person Interaction Note', :uuqa_157 do
      interaction_note = { :type => 'Meeting', :duration => '> 2h 30m', :content => Faker::Lorem.sentence(word_count:5) }
      overview_page.add_interaction(interaction_note)
      created_note = overview_page.first_note_in_timeline
      expect(created_note).to eql(interaction_note)
    end

  end
end