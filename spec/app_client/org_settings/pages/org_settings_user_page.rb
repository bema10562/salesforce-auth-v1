# frozen_string_literal: true

require_relative '../../root/pages/notifications'

module OrgSettings
  class UserTable < BasePage
    USER_TABLE = { css: '.ui-table > table > tbody > tr > td > a' }.freeze
    USER_TABLE_LOAD = { xpath: './/tbody/tr/td[text()="Loading"]' }.freeze
    USER_NAME_LIST = { css: '.ui-table-body > tr > td:nth-child(1) > a' }.freeze
    USER_EMAIL_LIST = { css: '.ui-table-body > tr > td:nth-child(2)' }.freeze
    USER_ROW_FIRST = { css: '.employee-table-row:nth-of-type(1) .ui-table-row-column' }.freeze

    ADD_USER_BTN = { css: '#add-user-btn' }.freeze
    USERS_TABLE = { css: '.ui-table-body' }.freeze
    USERS_SEARCH_BOX = { css: '#search-text' }.freeze

    def page_displayed?
      wait_for_table_load
      is_displayed?(USER_TABLE)
    end

    def wait_for_table_load
      is_not_displayed?(USER_TABLE_LOAD)
    end

    def get_list_of_user_names
      names = find_elements(USER_NAME_LIST)
      names.collect(&:text)
    end

    def get_list_of_user_emails
      emails = find_elements(USER_EMAIL_LIST)
      emails.collect(&:text)
    end

    def go_to_first_user
      click(USER_ROW_FIRST)
      wait_for_spinner
    end

    def go_to_user_with_id(user_id:)
      # Current work around to get provider id for route
      # To potentially be removed once we have context of provider per employee
      org = current_url.split('/')[4]
      get("/org/#{org}/users/#{user_id}")
      wait_for_spinner
    end

    def go_to_new_user_form
      click(ADD_USER_BTN)
    end

    def search_for(text)
      enter(text, USERS_SEARCH_BOX)
    end

    def no_users_displayed?
      is_not_displayed?(USER_ROW_FIRST)
    end

    def users_displayed?
      is_displayed?(USER_ROW_FIRST)
    end

    def matching_users_displayed?(text)
      names_and_emails = get_list_of_user_names.zip(get_list_of_user_emails)
      users_displayed? && names_and_emails.all? { |name_and_email| name_and_email.any? { |val| val.include?(text) } }
    end
  end

  class UserCard < BasePage
    USER_STATUS_INACTIVE_TEXT = 'Inactive'
    USER_STATUS_ACTIVE_TEXT = 'Active'

    USER_HEADER = { css: '.ui-base-card-header__title' }.freeze
    NAME_AND_TITLE_ROW = { css: '.common-display-profile.editable-panel' }.freeze
    FIRST_NAME_CELL = { css: '.common-display-profile.editable-panel .row .col-sm-9 .row div:nth-of-type(1) p:not(.subhead)' }.freeze
    LAST_NAME_CELL = { css: '.common-display-profile.editable-panel .row .col-sm-9 .row div:nth-of-type(2) p:not(.subhead)' }.freeze

    # NEW USER
    INPUT_FIRSTNAME = { css: '#first-name' }.freeze
    INPUT_LASTNAME = { css: '#last-name' }.freeze
    INPUT_EMAIL = { css: 'input[type="email"]' }.freeze
    INPUT_PHONE = { css: '#phone-number-0-number' }.freeze
    INPUT_WORK_TITLE = { css: '#work-title' }.freeze
    EMPLOYEE_STATE_CHOICES = { css: 'div[aria-activedescendant*="choices-state-item-choice"]' }.freeze
    EMPLOYEE_STATE_ACTIVE = { css: 'div[aria-activedescendant*="choices-state-item-choice"] .choices__item.choices__item--selectable[data-value="active"]' }.freeze
    INPUT_PROGRAM_CHOICES = { css: 'div[aria-activedescendant*="programs-item-choice"]' }.freeze
    INPUT_PROGRAM_ROLES = { css: 'div[aria-activedescendant*="roles-item-choice"]' }.freeze
    INPUT_ORG_ROLES = { css: 'div[aria-activedescendant*="org-roles-item-choice"]' }.freeze
    INPUT_PROGRAM_CHOICES_SELECTABLES = { css: 'div[aria-activedescendant*="programs-item-choice"] div.choices__list--multiple div.choices__item--selectable' }.freeze
    INPUT_ORG_ROLES_SELECTABLES = { css: 'div[aria-activedescendant*="org-roles-item-choice"] div.choices__list--multiple div.choices__item--selectable' }.freeze
    PROGRAM_ACCESS_CHOICES = { css: 'div[data-role="personal-information"] .profile-value' }.freeze

    # EXISTING USER
    EDITABLE_PERSONAL_INFO = { css: '#edit-personal-information-modal-btn' }.freeze
    BTN_CANCEL_PERSONAL = { css: '#personal-information-cancel-btn' }.freeze
    EDIT_PERSONAL_INFO_MODAL = { css: '#edit-personal-information-modal.dialog.open' }.freeze
    EDIT_PERSONAL_INFO_CLOSE_BUTTON = { css: '#edit-personal-information-modal .title-closeable .ui-icon' }.freeze
    EDIT_PERSONAL_INFO_SAVE_BUTTON = { css: '#edit-personal-information-modal #personal-information-submit-btn' }.freeze
    EDITABLE_EMAIL = { css: '#edit-email-address-modal-btn' }.freeze
    BTN_SAVE_EMAIL = { css: '#edit-email-save-btn' }.freeze
    EDIT_EMAIL_CLOSE_BUTTON = { css: '#edit-email-address-modal .title-closeable .ui-icon' }.freeze
    BTN_CANCEL_EMAIL = { css: '#edit-email-cancel-btn' }.freeze
    EDITABLE_PROGRAM = { css: '#edit-program-information-modal-btn' }.freeze
    BTN_SAVE_PROGRAM = { css: '#program-data-save-btn' }.freeze
    BTN_CANCEL_PROGRAM = { css: '#program-data-cancel-btn' }.freeze
    EDIT_PROGRAM_CLOSE_BUTTON = { css: '#edit-program-information-modal .title-closeable .ui-icon' }.freeze
    EDITABLE_NETWORK = { css: '#edit-network-licenses-modal-btn' }.freeze
    EDITABLE_ORG = { css: '#edit-group-licenses-modal-btn' }.freeze
    PROGRAM_ACCESS_DROPDOWN = { css: '.program-data-form .multiple-selector' }.freeze
    PROGRAM_ACCESS_DROPDOWN_CHOICES = { css: '.is-active [id^=choices-user-programs-item-choice]' }.freeze
    PROGRAM_ACCESS_SELECTIONS = { css: '.program-data-form .choices__inner' }.freeze
    PROGRAM_CHOICES = { css: '.dialog.open.large div[aria-activedescendant*="programs-item-choice"]' }.freeze
    PROGRAM_ROLES = { css: '.dialog.open.large div[aria-activedescendant*="roles-item-choice"]' }.freeze
    ORG_ROLES = { css: '.dialog.open.large div[aria-activedescendant*="org-roles-item-choice"]' }.freeze
    ORG_ROLE_DROPDOWN = { css: '.program-data-form__org-roles .multiple-selector' }.freeze
    ORG_ROLE_DROPDOWN_CHOICES = { css: '.is-active [id^=choices-org-roles-item-choice]' }.freeze
    ORG_ROLE_REMOVE_BUTTONS = { css: '.dialog.open.large #org-roles + div .choices__button' }.freeze
    ORG_ROLE_SELECTIONS = { css: '.program-data-form__org-roles .choices__inner' }.freeze # useful for getting text of selections
    EDITABLE_STATE = { css: '#edit-employee-state-modal-btn' }.freeze
    EDITABLE_STATE_MODAL = { css: '#edit-employee-state-modal.dialog.open' }.freeze
    STATE_DROPDOWN = { css: '.edit-employee-state-form__state-select .choices' }.freeze
    STATE_DROPDOWN_CHOICES = { css: '.edit-employee-state-form__state-select .choices .choices__item--selectable' }.freeze
    EDIT_STATE_SAVE_BUTTON = { css: '#edit-employee-state-save-btn' }.freeze

    def page_displayed?
      is_displayed?(USER_HEADER) &&
        is_displayed?(NAME_AND_TITLE_ROW)
    end

    def get_user_title
      text(USER_HEADER)
    end

    def new_user_fields_display?
      is_displayed?(INPUT_FIRSTNAME) && is_displayed?(INPUT_LASTNAME) && is_displayed?(INPUT_EMAIL) &&
        is_displayed?(INPUT_PHONE) && is_displayed?(INPUT_WORK_TITLE) && is_displayed?(EMPLOYEE_STATE_CHOICES) &&
        is_displayed?(INPUT_PROGRAM_CHOICES) && is_displayed?(INPUT_PROGRAM_ROLES) && is_displayed?(INPUT_ORG_ROLES)
    end

    def employee_state_active?
      is_displayed?(EMPLOYEE_STATE_ACTIVE)
    end

    def existing_user_fields_editable?
      edit_personal_info? && edit_email_info? && edit_program_access?
    end

    def edit_personal_info?
      click(EDITABLE_PERSONAL_INFO)
      is_displayed?(EDIT_PERSONAL_INFO_CLOSE_BUTTON) # wait for modal to glide down
      editable = is_displayed?(INPUT_FIRSTNAME) && is_displayed?(INPUT_LASTNAME) && is_displayed?(INPUT_WORK_TITLE)
      click(BTN_CANCEL_PERSONAL)
      editable
    end

    def edit_email_info?
      click(EDITABLE_EMAIL)
      is_displayed?(EDIT_EMAIL_CLOSE_BUTTON) # wait for modal to glide down
      editable = is_displayed?(INPUT_EMAIL)
      click(BTN_CANCEL_EMAIL)
      editable
    end

    def edit_program_access?
      click(EDITABLE_PROGRAM)
      is_displayed?(EDIT_PROGRAM_CLOSE_BUTTON) # wait for modal to glide down
      editable = is_displayed?(PROGRAM_CHOICES) && is_displayed?(PROGRAM_ROLES) && is_displayed?(ORG_ROLES)
      click(BTN_CANCEL_PROGRAM)
      editable
    end

    def go_to_edit_program_access
      click(EDITABLE_PROGRAM)
      is_displayed?(PROGRAM_CHOICES) && is_displayed?(PROGRAM_ROLES) && is_displayed?(ORG_ROLES)
    end

    def displayed_program_access_values
      # returns program access values displayed onder user page
      arr = find_elements(PROGRAM_ACCESS_CHOICES).map { |e| e.attribute('innerText').split(', ') }
      {
        program_choice_values: arr[0],
        # TODO: - remove empty string default value after implementing UU3-52069
        program_role_value: arr[1].first || '',
        org_role_values: arr[2]
      }
    end

    def displayed_org_role_access_values
      find_elements(PROGRAM_ACCESS_CHOICES).map { |e| e.attribute('innerText').split(', ') }[2]
    end

    def displayed_program_choice_values
      find_elements(PROGRAM_ACCESS_CHOICES).map { |e| e.attribute('innerText').split(', ') }[0]
    end

    def get_selectable_input_text(element)
      find_elements(element).map { |s| s.text.gsub('Remove item', '').strip }
    end

    def program_choice_values
      get_selectable_input_text(INPUT_PROGRAM_CHOICES_SELECTABLES)
    end

    def program_role_value
      text(PROGRAM_ROLES).gsub('Remove item', '').strip
    end

    def org_role_values
      get_selectable_input_text(INPUT_ORG_ROLES_SELECTABLES)
    end

    def add_program
      go_to_edit_program_access
      click(PROGRAM_ACCESS_DROPDOWN)
      program_element = find_elements(PROGRAM_ACCESS_DROPDOWN_CHOICES).sample
      program_new_value = program_element.text
      program_element.click
      unless text(PROGRAM_ACCESS_SELECTIONS).include? program_new_value
        raise StandardError, "E2E ERROR: #{program_new_value} was not added before saving, test is in an invalid state"
      end

      click(BTN_SAVE_PROGRAM)
      program_new_value
    end

    def add_org_role
      go_to_edit_program_access
      click(ORG_ROLE_DROPDOWN)
      org_role_element = find_elements(ORG_ROLE_DROPDOWN_CHOICES).sample
      org_new_value = org_role_element.text
      org_role_element.click
      unless text(ORG_ROLE_SELECTIONS).include? org_new_value
        raise StandardError, "E2E ERROR: #{org_new_value} was not added before saving, test is in an invalid state"
      end

      click(BTN_SAVE_PROGRAM)
      org_new_value
    end

    def remove_org_role
      go_to_edit_program_access
      org_role_element = find_elements(ORG_ROLE_REMOVE_BUTTONS).sample
      org_removed_value = org_role_element.attribute('aria-label').gsub('Remove item:', '').gsub("'", '').strip

      # Adding retries when clicking on the 'x' for the selected org role to avoid flakes
      max_retry_count = 2
      retry_count = 0
      while (text(ORG_ROLE_SELECTIONS).include? org_removed_value) && (retry_count <= max_retry_count)
        org_role_element.click
        p "E2E DEBUG: #{org_removed_value} was clicked to be removed, retry_count: #{retry_count}"
        retry_count += 1
      end

      if text(ORG_ROLE_SELECTIONS).include? org_removed_value
        raise StandardError, "E2E Error: #{org_removed_value}  was not removed before saving after #{retry_count} retries"
      end

      click(BTN_SAVE_PROGRAM)
      org_removed_value
    end

    def save_email_field
      click(EDITABLE_EMAIL)
      is_displayed?(EDIT_EMAIL_CLOSE_BUTTON) # wait for modal to glide down
      is_displayed?(INPUT_EMAIL)
      click(BTN_SAVE_EMAIL)
      is_not_displayed?(INPUT_EMAIL)
    end

    def edit_personal_info(first_name: nil, last_name: nil, work_title: nil)
      click(EDITABLE_PERSONAL_INFO)
      is_displayed?(EDIT_PERSONAL_INFO_CLOSE_BUTTON) # wait for modal to glide down
      clear_then_enter(first_name, INPUT_FIRSTNAME) unless first_name.nil?
      clear_then_enter(last_name, INPUT_LASTNAME) unless last_name.nil?
      clear_then_enter(work_title, INPUT_WORK_TITLE) unless work_title.nil?
      click(EDIT_PERSONAL_INFO_SAVE_BUTTON)
    end

    def personal_info_modal_not_present?
      is_not_present?(EDIT_PERSONAL_INFO_MODAL)
    end

    def name_and_title
      text(NAME_AND_TITLE_ROW)
    end

    def get_name
      "#{text(FIRST_NAME_CELL)} #{text(LAST_NAME_CELL)}"
    end

    def save_user_status(status: nil)
      click(EDITABLE_STATE)
      is_displayed?(EDITABLE_STATE_MODAL)
      click(STATE_DROPDOWN) unless status.nil?
      click_element_from_list_by_text(STATE_DROPDOWN_CHOICES, status) unless status.nil?
      click(EDIT_STATE_SAVE_BUTTON)
    end

    def user_status_modal_not_present?
      is_not_present?(EDITABLE_STATE_MODAL)
    end
  end
end
