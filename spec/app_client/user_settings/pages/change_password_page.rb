# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

module UserSettings
  class ChangePasswordPage < BasePage
    AUTH_FORM_CONTAINER = { css: '#auth-form-container' }.freeze
    CURRENT_EMAIL = { css: '.display-email' }.freeze
    CURRENT_PASSWORD_INPUT = { css: '#user_current_password' }.freeze
    NEW_PASSWORD_INPUT = { css: '#user_password' }.freeze
    CONFIRM_NEW_PASSWORD = { css: '#user_password_confirmation' }.freeze
    UPDATE_BUTTON = { xpath: "//input[@value='Update']" }.freeze
    CANCEL_BUTTON = { css: '.cancel-link' }.freeze

    # error messages:
    CURRENT_PW_TEXT = 'Current password is invalid'
    INSECURE_PW_TEXT = 'Password is not safe to use as it appears in a list of weak passwords. Please change your password to something more secure.'

    def page_displayed?
      is_displayed?(CURRENT_EMAIL) &&
        is_displayed?(CURRENT_PASSWORD_INPUT) &&
        is_displayed?(NEW_PASSWORD_INPUT) &&
        is_displayed?(CONFIRM_NEW_PASSWORD) &&
        is_displayed?(UPDATE_BUTTON) &&
        is_displayed?(CANCEL_BUTTON)
    end

    def cancel_password_reset
      click(CANCEL_BUTTON)
    end

    def change_password(current_pw:, new_pw:)
      enter(current_pw, CURRENT_PASSWORD_INPUT)
      enter(new_pw, NEW_PASSWORD_INPUT)
      enter(new_pw, CONFIRM_NEW_PASSWORD)
      click(UPDATE_BUTTON)
    end

    def insecure_pw_message_displayed?
      page_text.include?(INSECURE_PW_TEXT)
    end

    def page_text
      text(AUTH_FORM_CONTAINER)
    end
  end
end
