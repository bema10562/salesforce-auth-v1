require_relative '../../../shared_components/base_page'

class LeftNav < BasePage

  DASHBOARD_LINK = { css: '#nav-workflow-dashboard' }
  MY_NETWORK_LINK = { css: '#nav-network' }
  CLIENTS_LINK = {css: '#nav-clients'}
  
  def go_to_dashboard 
    click(DASHBOARD_LINK)
  end

  def go_to_my_network
    click(MY_NETWORK_LINK)
  end
  
  def go_to_clients
    click(CLIENTS_LINK)
  end

end
