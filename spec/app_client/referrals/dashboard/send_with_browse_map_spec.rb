# frozen_string_literal: true

require_relative '../../root/pages/right_nav'
require_relative '../../root/pages/home_page'
require_relative '../../referrals/pages/referral'
require_relative '../../referrals/pages/referral_send'
require_relative '../../referrals/pages/referral_network_map'
require_relative '../../referrals/pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:sent_referral_dashboard) { ReferralDashboard::Sent::All.new(@driver) }
  let(:referral_send) { ReferralSend.new(@driver) }
  let(:network_map) { ReferralNetworkMap.new(@driver) }

  context('[as a Referral user]') do
    before do
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent
      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id)

      # login in as org user where referral was sent
      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_03_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'user can send a new referral using Browse map', :uuqa_48, :uuqa_166 do
      # Opening send referral page
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      referral.send_referral_action

      # Opening browse map, clearing the filter and selecting the top most organization in list
      expect(referral_send.page_displayed?).to be_truthy
      referral_send.open_network_browse_map

      expect(network_map.page_displayed?).to be_truthy
      network_map.clear_all_filters_and_close_drawer
      recipient = network_map.add_first_organization_from_list
      network_map.add_organizations_to_referral

      # Checking that the dropdown has the same org we selected in browse map
      expect(referral_send.page_displayed?).to be_truthy
      expect(referral_send.selected_organization).to eq(recipient)
      referral_send.send_referral

      # Newly created referral should display on sent all referral dashboard with new recipient and user
      status = 'Needs Action'
      sent_by = 'Princeton Ivy'

      expect(sent_referral_dashboard.page_displayed?).to be_truthy
      expect(sent_referral_dashboard.headers_displayed?).to be_truthy
      expect(sent_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(recipient, sent_by, status, @referral.service_type)

      # On send a new referral id is created, but navigating with the old referral id redirects us to the new referral id
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      expect(referral.recipient_info).to eq(recipient)
      @referral.id = referral.current_referral_id
    end

    after do
      # closing referral for cleanup purposes
      Setup::Data.recall_referral_in_princeton(note: 'Data cleanup')
      Setup::Data.close_referral_in_princeton(note: 'Data cleanup')
    end
  end
end
