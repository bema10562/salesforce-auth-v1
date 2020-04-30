require_relative '../../../spec_helper'
require_relative '../pages/login_email'
require_relative '../pages/login_password'

module Login

RSpec.configure do |config|
  config.before(:each) do 
    @login_email = LoginEmail.new(@driver)
    @login_password = LoginPassword.new(@driver)
  end
end

  attr_reader :email_address, :password
  
  # TODO UU3-26998 UU3-26999 UU3-27000 UU3-27001
  # manage users per staging, training, and prod envs
  # evaluate feasibility of reducing array of users and generating machine tokens
  TEST_USERS = [
    # cc user for testing business intelligence tracking
    BI_CC_USER = 'cc@bi.test',
    # primary cc used in tests
    CC_HARVARD = 'harvard@auto.com',
    # EHR user with screenings role
    EMR_SCREENINGS_USER = 'screenings@emr.com',
    # EHR user with no screenings permissions
    EMR_NON_SCREENINGS_USER = 'noscreenings@emr.com',
    # user configured with Tableau license for Insights feature
    INSIGHTS_USER = 'insights@auto.com',
    # used in createIntakeOrgIntakeUser.js
    INTAKE_USER = 'intake@auto.com',
    # same as nolicense; should be consolidated
    INVALID_USER = 'martin@auto.com',
    # used in parts/login/nonLicensedUser.js
    NOLICENSE_MARTIN = 'martin@auto.com',
    # used in 3 tests and 2 helper scripts
    ORG_ATLANTA = 'atlanta@auto.com',
    # used in ~15 ui-tests
    ORG_COLUMBIA = 'columbia@auto.com',
    # used in ~20 ui-tests
    ORG_NEWYORK = 'newyork@auto.com',
    # used in 2 tests and 1 helper script
    ORG_PRINCETON = 'princeton@auto.com',
    # primary org used in tests
    ORG_YALE = 'yale@auto.com',
    # used in 3 tests
    REFERRAL_USER = 'referral@auto.com',
    # used in dashboardNavigationSN.js
    # might become obsolete or applied to referrals tests
    SUPER_USER = 'super@best.com',
    # settings user, QA network
    SETTINGS_USER = 'qa.perms@auto.com'
  ]

  DEFAULT_PASSWORD = 'Uniteus1!'
  WRONG_PASSWORD = 'Uniteus' # can be passed to log_in_as method instance

 def log_in_as(email_address, password = DEFAULT_PASSWORD)
    base_page.get ''
    expect(login_email.page_displayed?).to be_truthy

    login_email.submit(email_address)
    expect(login_password.page_displayed?).to be_truthy

    login_password.submit(password)
  end
  
end
