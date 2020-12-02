require_relative '../../../shared_components/base_page'

class ProcessedAssistanceRequestDashboardPage < BasePage
  PROCESSED_AR_DASHBOARD_TABLE = { css: '#processed-assistance-requests-table' }.freeze
  
  def go_to_processed_ar_dashboard_page
    get("/dashboard/assistance-requests/processed")
    wait_for_spinner
  end

  def processed_ar_dashboard_page_displayed?
    is_displayed?(PROCESSED_AR_DASHBOARD_TABLE)
  end
end