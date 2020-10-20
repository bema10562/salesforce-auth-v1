require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page'
require_relative '../root/pages/navbar'
require_relative './pages/network'

describe '[Network]', :ehr, :network do
  include LoginEhr

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:navbar) { Navbar.new(@driver) }
  let(:network) { Network.new(@driver) }

  context('[as a cc user] in the Dashboard view') do
    before {
      log_in_dashboard_as(LoginEhr::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
      navbar.go_to_my_network
      expect(network.page_displayed?).to be_truthy
    }

    it 'can filter by text', :uuqa_1548 do
      @provider_search_text = "Princeton"
      # TODO: https://uniteus.atlassian.net/browse/UU3-48920
      # replace hardcoded search term with provider name from API
      network.search_by_text(text: @provider_search_text)
      # verify at least one result:
      expect(network.search_result_text).to include("result")
      expect(network.first_provider_name).to include(@provider_search_text)
    end
  end
end