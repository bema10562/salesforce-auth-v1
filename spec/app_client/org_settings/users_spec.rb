# frozen_string_literal: true

require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'
require_relative '../root/pages/right_nav'
require_relative './pages/org_settings_user_page'

# Temporarily skipping while we debug this test case's failures
# A separate jenkins job will run this test case in the meantime on BrowserStack
# https://jenkins.devops.uniteus.io/qa-jenkins/job/end-to-end-tests/job/Staging/job/users_spec_staging/
xdescribe '[Org Settings - Users]', :org_settings, :app_client do
  let(:home_page) { HomePage.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:org_settings_user_table) { OrgSettings::UserTable.new(@driver) }
  let(:org_settings_user_form) { OrgSettings::UserCard.new(@driver) }
  let(:employee_id) do
    Setup::Data.initialize_employee_with_role_and_program_in_qa_admin(current_user_email_address: Users::SETTINGS_USER)
  end

  context('[as an org admin]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::SETTINGS_USER)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      org_menu.go_to_users_table
      expect(org_settings_user_table.page_displayed?).to be_truthy
    end

    it 'displays users in alphabetical order', :uuqa_809 do
      expect(org_settings_user_table.get_list_of_user_names.each_cons(2).all? do |a, b|
               a.downcase <= b.downcase
             end).to be_truthy
    end

    it 'can view new user form', :uuqa_354 do
      org_settings_user_table.go_to_new_user_form
      expect(org_settings_user_form.get_user_title).to eql('New User')
      expect(org_settings_user_form.new_user_fields_display?).to be_truthy
      expect(org_settings_user_form.employee_state_active?).to be_truthy
    end

    it 'can view and edit existing user form', :uuqa_355 do
      org_settings_user_table.go_to_first_user
      expect(org_settings_user_form.existing_user_fields_editable?).to be_truthy
      org_settings_user_form.save_email_field

      notification_text = notifications.success_text
      expect(notification_text).to eql Notifications::USER_UPDATED
    end

    it 'can update user personal info', :uuqa_1708 do
      org_settings_user_table.go_to_first_user

      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      work_title = Faker::Job.title

      org_settings_user_form.edit_personal_info(first_name: first_name, last_name: last_name, work_title: work_title)

      expect(org_settings_user_form.personal_info_modal_not_present?).to be_truthy

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::USER_UPDATED)

      # refreshing the page to ensure that the name values have updated
      org_settings_user_form.refresh
      expect(org_settings_user_form.name_and_title).to include(first_name)
      expect(org_settings_user_form.name_and_title).to include(last_name)
      expect(org_settings_user_form.name_and_title).to include(work_title)
    end

    it 'can view prepopulated program access fields', :uuqa_1668 do
      org_settings_user_table.go_to_first_user
      expect(org_settings_user_form.page_displayed?).to be_truthy
      program_access_values = org_settings_user_form.displayed_program_access_values

      org_settings_user_form.go_to_edit_program_access
      expect(org_settings_user_form.program_choice_values).to eq program_access_values[:program_choice_values]
      expect(org_settings_user_form.program_role_value).to eq program_access_values[:program_role_value]
      expect(org_settings_user_form.org_role_values).to eq program_access_values[:org_role_values]
    end

    it 'can add a program to an employee', :uuqa_1705 do
      org_settings_user_table.go_to_user_with_id(user_id: employee_id)
      expect(org_settings_user_form.page_displayed?).to be_truthy

      original_program_values = org_settings_user_form.displayed_program_choice_values

      program_added = org_settings_user_form.add_program
      expect(notifications.success_text).to include(Notifications::USER_UPDATED)
      org_settings_user_form.refresh
      expect(org_settings_user_form.page_displayed?).to be_truthy
      expected_values = original_program_values + [program_added]
      actual_values = org_settings_user_form.check_updated_ui_values(
        :displayed_program_choice_values, original_values: original_program_values
      )
      expect(actual_values).to match_array_with_ui_lag_msg(expected_values)
    end

    it 'can add an employee org role', :uuqa_1706 do
      org_settings_user_table.go_to_user_with_id(user_id: employee_id)
      expect(org_settings_user_form.page_displayed?).to be_truthy

      original_org_role_values = org_settings_user_form.displayed_org_role_access_values

      org_role_added = org_settings_user_form.add_org_role
      expect(notifications.success_text).to include(Notifications::USER_UPDATED)
      org_settings_user_form.refresh
      expect(org_settings_user_form.page_displayed?).to be_truthy
      expected_values = original_org_role_values + [org_role_added]
      actual_values = org_settings_user_form.check_updated_ui_values(
        :displayed_org_role_access_values, original_values: original_org_role_values
      )
      expect(actual_values).to match_array_with_ui_lag_msg(expected_values)
    end

    it 'can remove an employee org role', :uuqa_1707 do
      org_settings_user_table.go_to_user_with_id(user_id: employee_id)
      expect(org_settings_user_form.page_displayed?).to be_truthy

      original_org_role_values = org_settings_user_form.displayed_org_role_access_values

      org_role_removed = org_settings_user_form.remove_org_role
      expect(notifications.success_text).to include(Notifications::USER_UPDATED)
      org_settings_user_form.refresh
      expect(org_settings_user_form.page_displayed?).to be_truthy
      expected_values = original_org_role_values - [org_role_removed]
      actual_values = org_settings_user_form.check_updated_ui_values(
        :displayed_org_role_access_values, original_values: original_org_role_values
      )
      expect(actual_values).to match_array_with_ui_lag_msg(expected_values)
    end

    it 'can save employee status', :uuqa_1767 do
      org_settings_user_table.go_to_first_user

      org_settings_user_form.save_user_status
      expect(org_settings_user_form.user_status_modal_not_present?).to be_truthy

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::USER_UPDATED)
    end
  end
end
