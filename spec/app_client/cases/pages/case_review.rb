# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class CaseReview < BasePage
  DESCRIPTION_IN_NETWORK = { css: '.detail-review__row:nth-of-type(3) .detail-review__text--short' }.freeze
  DOCUMENT_NAME = { xpath: ".//span[text()='%s']" }
  EDIT_BUTTON = { css: '.detail-review__footer #edit-case-btn' }.freeze
  NOTES = {  css: '.detail-review__row:nth-of-type(4) .detail-review__text--short' }.freeze
  PRIMARY_WORKER = { css: '.detail-review__row:nth-of-type(2) .col-xs-6:nth-of-type(2) .detail-review__text--short' }.freeze
  REFERRED_TO = {  css: '.detail-review__row:nth-of-type(3) .detail-review__text--short' }.freeze
  REVIEW_FORM = { css: '.case-review' }.freeze
  SERVICE_TYPE = { css: '.detail-review__row:nth-of-type(1) .detail-review__text--short' }.freeze
  STEPPER = { css: '.MuiStepper-root.MuiStepper-horizontal' }.freeze
  SUBMIT_BUTTON = { css: '#submit-case-btn' }.freeze

  def page_displayed?
    is_displayed?(STEPPER) &&
      is_displayed?(REVIEW_FORM) &&
      is_displayed?(EDIT_BUTTON) &&
      is_displayed?(SUBMIT_BUTTON)
  end

  def click_submit_button
    click(SUBMIT_BUTTON)
    wait_for_spinner
  end

  def description_in_network
    text(DESCRIPTION_IN_NETWORK)
  end

  def document_uploaded?(file_name:)
    is_displayed?(DOCUMENT_NAME.transform_values { |v| v % file_name })
  end

  def notes
    text(NOTES)
  end

  def primary_worker
    text(PRIMARY_WORKER)
  end

  def referred_to
    text(REFERRED_TO)
  end

  def service_type
    text(SERVICE_TYPE)
  end
end
