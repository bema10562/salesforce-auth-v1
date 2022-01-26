# https://uniteus4.my.salesforce.com

require_relative '../../shared_components/base_page'

class SalesforceAuthPage < BasePage

  EMAIL_INPUT = {css: '#username', name: '#username'}.freeze
  PASSWORD_INPUT = {css: '#password'}.freeze
  LOGIN_BTN = {css: '#Login'}.freeze
  REMEMBER_ME_BUTTON = {css: '#rememberUn'}.freeze

  def auth_page_displayed?
    check_displayed?(EMAIL_INPUT)
  end

  def enter_email_address
    clear_then_enter('fine-01curls@icloud.com', EMAIL_INPUT)
  end

  def enter_password
    clear_then_enter(ENV['SALESFORCE_DEFAULT_PASSWORD'], PASSWORD_INPUT)
  end

  def enter_credentials
    enter_email_address
    enter_password
  end

  def click_next_button
    find(LOGIN_BTN).click
  end

  def click_login
    click(LOGIN_BTN)
  end

  def navigate_to_salesforce
    get('')
  end

  def check_remember_me
    click(REMEMBER_ME_BUTTON) unless is_checked?(REMEMBER_ME_BUTTON)
    end

  # email: fine-01curls@icloud.com
  # url : https://uniteus4.my.salesforce.com
  # PW: UniteUs999!
end
