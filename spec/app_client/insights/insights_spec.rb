# frozen_string_literal: true
require_relative './pages/insights'
require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'

describe '[Insights - ]', :insights, :users do
  include Login

  let(:insights) { Insights.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }

  it 'downloads report and verifies Tableau iFrame', :uuqa_509 do
    log_in_as(email_address: Users::INSIGHTS_USER)
    expect(home_page.page_displayed?).to be_truthy
    expect(insights.insight_nav_displayed?).to be_truthy
    insights.click_insight_nav

    # verify csv report download
    insights.get_current_download_count
    insights.select_activity_first_option
    insights.select_file_type_csv
    insights.click_download
    insights.get_download_count_after
    expect(insights.download_success?).to be_truthy
    insights.first_file_contains(".csv")
    # verify image report download
    insights.get_current_download_count
    insights.select_activity_first_option
    insights.select_file_type_image
    insights.click_download
    insights.get_download_count_after
    expect(insights.download_success?).to be_truthy
    insights.first_file_contains(".png")
    # verify PDF report
    insights.get_current_download_count
    insights.select_activity_first_option
    insights.select_file_type_pdf
    insights.click_download
    insights.get_download_count_after
    expect(insights.download_success?).to be_truthy
    insights.first_file_contains(".pdf")
    # verify tableau Iframe
    expect(insights.tableau_iframe_exists?).to be_truthy
  end
end
