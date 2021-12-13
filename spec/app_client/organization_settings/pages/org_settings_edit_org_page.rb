# frozen_string_literal: true

module OrgSettings
  class EditOrgInfo < BasePage
    include ContactComponents

    CANCEL_BUTTON = { css: '[data-test-element=cancel]' }
    EDIT_ORG_INFO_HEADING = { css: '[data-test-element=heading]' }

    INPUT_NAME = { css: 'input[id=org-name]' }
    INPUT_DESCRIPTION = { css: '.public-DraftEditor-content' }
    INPUT_WEBSITE = { css: 'input[id=org-website]' }

    SAVE_BUTTON = { css: '[data-test-element=save]' }

    def page_displayed?
      is_displayed?(EDIT_ORG_INFO_HEADING) &&
      is_displayed?(CANCEL_BUTTON) &&
      is_displayed?(SAVE_BUTTON)
    end

    def save_description(description)
      save_field(input_field: INPUT_DESCRIPTION, text_value: description)
    end

    def get_description
      text(TEXT_DESCRIPTION)
    end

    def save_website(website)
      save_field(input_field: INPUT_WEBSITE, text_value: website)
    end

    def get_website
      text(TEXT_WEBSITE)
    end

    def save_phone(phone)
      select_phone_type_fax
      save_field(input_field: INPUT_PHONE_NUMBER_FIRST, text_value: phone)
    end

    def get_phone
      text(INPUT_PHONE_NUMBER_FIRST)
    end

    def save_email(email)
      save_field(input_field: INPUT_EMAIL_FIRST, text_value: email)
    end

    def get_email
      text(TEXT_EMAIL)
    end

    def get_time
      text(TEXT_HOURS_MONDAY)
    end

    def save_time(time)
      click_via_js(INPUT_HOURS_OPEN_FIRST)
      click_element_from_list_by_text(LIST_HOURS, time)
      click_via_js(SAVE_BUTTON)
    end

    private
    def save_field(input_field:, text_value:)
      delete_all_char(input_field)
      enter(text_value, input_field)
      click_via_js(SAVE_BUTTON)
    end

    def select_phone_type_fax
      click_via_js(PHONE_TYPE_SELECT_LIST)
      click_element_from_list_by_text(PHONE_TYPE_CHOICES, PHONE_TYPE_FAX)
    end
  end
end
