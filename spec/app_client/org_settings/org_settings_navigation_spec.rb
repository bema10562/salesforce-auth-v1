# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative './pages/org_settings_navigation'
require_relative './pages/org_settings_profile_page'
require_relative './pages/org_settings_programs_page'
require_relative './pages/org_settings_user_page'

describe '[Org Settings Navigation]', :org_settings, :app_client do
  include Login

  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:org_settings_profile) { OrgSettings::Profile.new(@driver) }
  let(:org_settings_navigation) { OrgSettings::Navigation.new(@driver) }
  let(:org_settings_program_table) { OrgSettings::ProgramTable.new(@driver) }
  let(:org_settings_user_table) { OrgSettings::UserTable.new(@driver) }

  context('[As an org admin]') do
    before do
      log_in_as(Login::CC_HARVARD)
    end

    it 'Navigate through Org Settings Tabs', :uuqa_323, :uuqa_322, :uuqa_321 do
      org_menu.go_to_users_table
      org_settings_navigation.go_to_profile_tab
      expect(org_settings_profile.page_displayed?).to be_truthy
      org_settings_navigation.go_to_programs_tab
      expect(org_settings_program_table.page_displayed?).to be_truthy
      org_settings_navigation.go_to_users_tab
      expect(org_settings_user_table.page_displayed?).to be_truthy
    end
  end
end