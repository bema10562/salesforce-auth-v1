require_relative '../../../shared_components/base_page'

class HomePageEhr < BasePage
  ASSESSMENTS_SECTION = { css: '.assessment-forms' }
  CASES_SECTION = { css: '.cases' }
  CREATE_REFERRAL_BUTTON = { css: '#nav-referral' }
  NAVBAR = { css: '.navigation' }
  SCREENINGS_SECTION = { css: '.screenings' }


  def default_view_displayed?
    # extending timeout for test cases that create multiple referrals i.e. uuqa_1771
    # and there is a delay in returning to the homepage
    is_displayed?(NAVBAR, 60) &&
      is_displayed?(CREATE_REFERRAL_BUTTON) &&
      is_displayed?(CASES_SECTION) &&
      is_displayed?(ASSESSMENTS_SECTION) &&
      is_displayed?(SCREENINGS_SECTION)
  end

  def get_screening_detail(contact_id:, screening_id:)
    session_id = ehr_session_support_id
    get "/#{session_id}/contact/#{contact_id}/screenings/#{screening_id}"
  end

  def go_to_create_referral
    click(CREATE_REFERRAL_BUTTON)
  end

  def page_displayed?
    is_displayed?(NAVBAR)
  end

  # must be on the home page in patient context
  def contact_id
    current_url.split("#{ENV['WEB_URL']}/").last.split('/').last
  end

  # When using EHR in a browser, the base URL is followed by an ID which is dynamically generated
  # toward managing different sessions in EHR desktop apps (Epic, Cerner).
  def ehr_session_support_id
    current_url.split("#{ENV['WEB_URL']}/").last.split('/').first
  end
end