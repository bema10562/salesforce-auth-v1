# About

This repository contains end-to-end, browser-based tests on Unite Us customer-facing applications simulating the user experience. These tests execute the happy path of critical features on [all supported browsers](https://stackoverflow.com/c/unite-us/questions/94/95#95).

The following test environments may be included in the scope of this project:

- [x] Regression tests for Dev QA and Staging
- [ ] Smoke tests for Training and Production (Important! Smoke tests _must_ be generic enough to work for test users in all environments)

This repository is a core to our CI initiatives [UU3-28288](https://uniteus.atlassian.net/browse/UU3-28288) enabling us to run select end-to-end tests in application and service pipelines.

# Getting Started

## Install Ruby

While most current OSs ship with Ruby installed, using a global Ruby version for development is ill-advised. You need a Ruby version manager as different projects use different versions. Popular choices include

- rvm
- rbenv
- chruby

Each tool has its pros and cons, and no one choice is correct. That said, Rubyists tend to to be highly opionated, and there are approximately one million blog posts on which version manager is better and why. Share your selection at the risk of sparking a lengthy debate. I'll confess I like rvm. I don't disagree with the bloat arguments against it. Don't @ me.

Once you make your choice, follow the version-manager instructions on installing and using the version you need for a given project. Per convention, the version used in this project is defined in the `.ruby-version` file.

## Install Bundler and Rake

Confirm you have [Bundler](http://bundler.io/) installed:

`which bundler`

And [Rake](http://docs.seattlerb.org/rake/):

`which rake`

If you get a not-found response to either, install the missing dependencies with `gem install bundler` or `gem install rake` and try again; you should get returned the system path of your installation.

## Install Project

Clone this repository and install its dependencies:

`cd end-to-end-tests/ && bundle install`

## Install Web Drivers

This repository has to date been optimized to run on OS X. If you are setting up this project on an alternate OS please contribute to these instructions.

Note: There is a [webdrivers gem](https://github.com/titusfortner/webdrivers) which manages browser drivers, but its versions may not match your browser versions which will cause problems.

### ([Chromedriver](http://chromedriver.chromium.org/))

`brew tap homebrew/cask`
`brew cask install chromedriver`

### ([Geckodriver](https://github.com/mozilla/geckodriver)) (for Firefox)

Download from the [project releases](https://github.com/mozilla/geckodriver/releases) page and extract the server to somewhere on your `PATH`.

### Safari 
No driver needed. Launch your Safari instance, go to the Develop menu, and select "Allow Remote Automation."

Note: Braking changes were confirmed with Safari 13. They are fixed in [Safari Technology Preview 97](https://github.com/SeleniumHQ/selenium/issues/7649) but not yet a released version.

### Windows Browsers
If using BrowserStack, no local drivers are needed. If local drivers are needed, install [IEDriverServer](https://github.com/SeleniumHQ/selenium/wiki/InternetExplorerDriver) for IE and [msedgedriver](https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/) for MS Edge. 

We will leverage BrowserStack for cross-browser testing.

## Create a BrowserStack User Account

We run tests on Windows browsers using [BrowserStack](http://www.browserstack.com). To gain access, copy lib/`browserstack_credentials.rb.example` to lib/`browserstack_credentials.rb` and set your BrowserStack username and access key. If you need to be added as a user on our team, see an admin of our BrowserStack account (@carolmirakove).

The full test result output including screenshots and video is available in BrowserStack's [Automate view](https://www.browserstack.com/automate). BrowserStack results configs are set in the `spec_helper` file.

# Running Tests Locally

Run tests from the root path of this project in a Terminal window.

## Using Rake Tasks

See the `Rakefile` for examples of how to run defined tasks.
Call `rake -T` to list all tasks. Feel free to add useful tasks.

## Using RSpec Commands

When running tests via `rspec` the default `base_url` and `browser` values defined in the `spec_helper` will be used unless otherwise specified before the `rspec` command.

### Running Tests Headlessly

`chrome_headless` is defined in the `spec_helper`. You can use it via rake task or by passing the `browser` env var at runtime, e.g.,

`browser='chrome_headless' rspec --tag smoke`

### Passing a Dev QA URL

You can pass a Dev QA URL at runtime, e.g.,
`base_url='https://devqa.uniteusdev.com/uu3-#####' rspec --tag smoke`

Or set a value in `spec/spec_helper.rb` replacing `ENTER_URL_HERE`.

### Including or Excluding Tags

To run all tests tagged smoke:

`rspec --tag smoke`

To run all tests without the tag smoke:

`rspec -t ~smoke`

### Passing a Folder or Filenames

To run all tests in the `networks` folder:

`rspec spec/networks/`

To run all tests in the `networks/browse_map_spec` file:

`rspec spec/networks/browse_map_spec.rb`

To run only the test in `networks/browse_map_spec` at line 20:

`rspec spec/networks/browse_map_spec.rb:27`

To run two tests in `networks/browse_map_spec` at lines 20 and 31:

`rspec spec/networks/browse_map_spec.rb:27:40`

# Running Tests via Docker

- TODO [UU3-35283](https://uniteus.atlassian.net/browse/UU3-35283)

# Developing Tests

Tests are comprised of three types of activities:

- Arrange: navigate to component under test
- Act: interact with an element
- Assert: expect the presence or state of an element

Specs should be written in and reviewed for their [declarative](https://www.thoughtworks.com/insights/blog/imperative-vs-declarative-style-writing-twist-scenarios) not [imperative](https://wiki.saucelabs.com/display/DOCS/Best+Practice%3A+Imperative+v.+Declarative+Testing+Scenarios) style.

## Page Objects

Page Objects, developed and popularized by Google, have proven to be a best practice for tests executed through a UI and we are using them in this repository. If you're new to Page Objects, you can read [Google's page on their utility](https://code.google.com/p/selenium/wiki/PageObjects) and [Martin Fowler's related article](http://martinfowler.com/bliki/PageObject.html).

### Page Objects guidelines in this project

- Page-object classes should contain (1) constants defining selectors on the relevant page, and (2) functions to be called by specs
- If a route contains three tabs (e.g., /network is a parent to browse map, orgs, and users), create one page object for each tab
- Similarly modals warrant distinct page-object classes
- Method activities are limited to locating and interacting with elements
- Page object methods do not as a general rule contain assertions; assertions should be executed in a spec or spec helper
- Spec helpers are comprised of multiple page object methods for DRY purposes (e.g., a helper called log_in_as could contain the steps to load the home page, click log in, and submit a user's credentials)
  - Helper methods should be moved to back-end calls if possible (e.g., send an API request to set up the conditions required by the test, or use machine tokens to bypass the UI login flow)

### Tagging guidelines

Each example should be tagged with the following parameters:

- its corresponding UUQA JIRA test case ID, e.g., `:uuqa_652`
- the application under test, e.g., `:app_client`
- `:smoke` for happy-path tests that would result in a P0 if failed
- `:browsers_all` for tests that need to be run on all browsers
- `:browsers_chrome` for tests that need to be run on only one browsers
- `:parallel` for tests that can be run in parallel
- `:single_threaded` for tests that cannot be run in parallel
- `:pending => "UU3-##### reason test is skipped"` where the reason includes a JIRA ticket ID, e.g., known bug (there are several ways to skip examples, but this is the most expressive approach, cf. [the rspec-core docs](https://www.rubydoc.info/github/rspec/rspec-core/RSpec/Core/Pending))

The tagging effort is significant, mostly by design.

#### Intentional effort

Thoughtful Test design is at least as meaningful as clean coding. Deciding whether a test case is a smoke vs. regression test and whether it neeeds to be run on all browsers vs. just one browser are high-value expressions that we should take care to optimize.

#### Arbitrary effort

Running tests by tags rather than directory is optimal for its flexibility, but because we are housing tests for multiple projects in a common repository we need to tag the relevant application because distinct base URLs need to be passed for each.

### Other development guidelines

- Value readability over magic!
- No hard-coded data: Tests must be generic enough to run on staging, training, or production
- Run new tests repeatedly to verify they are not flaky
- Specs are organized with their respective page-objects as children; if page-obects from features not under test are dependencies (e.g., navigating through clients to create a referral), we should create a JIRA ticket to devise a solution by which we can avoid irrelevant UI navigation.

## Coding Style

- TODO [UU3-25213](https://uniteus.atlassian.net/browse/UU3-35213)

## Naming Conventions

### Specs

Files and descriptions in `spec/` are named by feature, context, and test case, e.g.,

```
describe '[Network]', :network do # description and tag match Feature in UUQA JIRA project
  ...
  context('[as cc user]') do # define the user executing the test
    ...
    context('[on Browse Drawer Share Form]') do # define the component under test
      ...
      it 'shares provider details via email', :uuqa_652, :app_client, :smoke, :cross_browser, :parallel do # describe the scenario
        ...
```

Brackets for describe and context are used for test results readability.

### Pages

Files and classes in `pages/` are named for the top route of the feature under test.

Page classes inherit from `spec/base_page`. The methods in the base page class may be used and useful to all page classes in all applications. 

## Debugging

The Gemfile contains byebug. See the project readme for use:
https://github.com/deivid-rodriguez/byebug

Once you put in a breakpoint you can interact with your paused test from the command like. Here are some examples of commands you might sent to the browser:

- find an element with a pseudo-selector:
  `(byebug) @driver.find_element(:css, '.provider-card-add-remove-button a:nth-of-type(1)')`
  `#<Selenium::WebDriver::Element:0x..f698e5e626e31ecc id="5dd2e832-d743-4d2f-8f57-2ddedafb106f">`

- click an element
  `(byebug) @driver.find_element(:css, 'input[value="Next"]').click`
  `nil`

- verify if an element is displayed: negative case
  `(byebug) @driver.find_element(:css, '.forgot-password-link').displayed?`
  `*** Selenium::WebDriver::Error::NoSuchElementError Exception: no such element: Unable to locate element: {"method":"css selector","selector":".forgot-password-link"}`

- verify if an element is displayed: positive case
  `(byebug) @driver.find_element(:css, '#forgot-password-link').displayed?`
  `true`

## Pull Requests

PRs to this project should follow the template in the `.github` directory.

# Test Results

## Console Output

Error handling is defined in the base page object, `pages/page.rb`.

## Reporting

### Stage 1: Achieve parity with [ui-tests](http://github.com/unite-us/ui-tests)

- Jenkins

  - [ ]  TODO [UU3-35212](https://uniteus.atlassian.net/browse/UU3-35212)
    - [ ] configure server to run tests headlessly
    - [ ] configure server to send tests to BrowserStack
    - [ ] install plugin for test results

- BrowserStack
  - [x] configure Video on Failure
  - [x] descriptive test names (improvement)
  - [x] one result per example (improvement)
  - [ ] TODO [UU3-35280](https://uniteus.atlassian.net/browse/UU3-35280) update dashboard with test result

### Stage 2: Evaluate enhancements

- [ ] Errors with embedded screenshots
  - [ ] Spike viability of Allure
