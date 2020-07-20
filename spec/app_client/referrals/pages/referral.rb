require_relative '../../../../lib/file_helper'

class Referral < BasePage
  ASSESSMENT_LIST = { css: '.detail-info__relationship-files' }
  ASSESSMENT_LINK = { xpath: './/a[text()="%s"]' }
  MILITARY_ASSESSMENT = { css: '#military-information-link' }
  REFERRAL_STATUS = { css: '.detail-status-text.uppercase' }

  TAKE_ACTION_DROP_DOWN = { css: '.action-select-container' }
  TAKE_ACTION_HOLD_OPTION =  { css: 'div[data-value="holdForReview"]' }
  TAKE_ACTION_SEND_OPTION = { css: 'div[data-value="send"]' }
  TAKE_ACTION_ACCEPT_OPTION = { css: 'div[data-value="accept"]' }

  ACCEPT_MODAL = { css: '.accept-modal-dialog .dialog.open.large .dialog-paper'}
  ACCEPT_PROGRAM_OPTIONS = { css: 'div[aria-activedescendant="choices-programSelect-item-choice-1"]' }
  ACCEPT_FIRST_PROGRAM_OPTION = { css: '#choices-programSelect-item-choice-1' }
  ACCEPT_PRIMARY_WORKER_OPTIONS =  { css: '.accept-referral-primary-worker-select .choices:not(.is-disabled)' }
  ACCEPT_FIRST_PRIMARY_WORKER_OPTION = { css: '#choices-workerSelect-item-choice-1' }
  ACCEPT_SAVE_BTN = { css: '#accept-referral-submit-btn' }

  HOLD_REFERRAL_MODAL = { css: '.dialog.open.large .hold-modal-form' }
  HOLD_REFERRAL_REASON_DROPDOWN = { css: '.referral-reason-field' }
  HOLD_REFERRAL_REASON_OPTION = { css: '.is-active .choices__item.choices__item--choice.choices__item--selectable' }
  HOLD_REFERRAL_NOTE = { css: '.hold-modal-form #noteInput' }
  HOLD_REFERRAL_BTN = { css: '#hold-referral-hold-btn' }

  SENDER_INFO = { css: '#basic-table-sender-value' }
  RECIPIENT_INFO = { css: '#basic-table-recipient-value'}

  DOCUMENT_ADD_LINK = { css: '#upload-document-link' }
  DOCUMENT_ATTACH_MODAL = { css: '.dialog.open.large'}
  DOCUMENT_ATTACH_BTN = { css: '#upload-submit-btn' }
  DOCUMENT_FILE_INPUT = { css: 'input[type="file"]' }
  DOCUMENT_PREVIEW = { css: '.preview-item' }
  DOCUMENT_LIST = { css: '.list-view-document__title' }
  DOCUMENT_EMPTY_LIST = { css: '.empty-documents-text' }

  DOCUMENT_LINK = { xpath: './/a[text()="%s"]'}
  DOCUMENT_REMOVE = { xpath: './/a[text()="%s"]/following-sibling::div[@class="remove-document"]' }
  DOCUMENT_REMOVE_MODAL = { css: '.dialog.open.mini'}
  DOCUMENT_REMOVE_BTN = { css: '.confirmation-dialog__actions--confirm'}

  TIMELINE_LOADING = { css: '.activity-stream .loading-entries__content' }
  STATUS_TEXT = { css: '.detail-status-text' }

  IN_REVIEW_STATUS = 'IN REVIEW'
  ACCEPTED_STATUS = 'ACCEPTED'

  def go_to_new_referral_with_id(referral_id:)
    get("/dashboard/new/referrals/#{referral_id}")
    wait_for_spinner
  end

  def go_to_in_review_referral_with_id(referral_id:)
    get("/dashboard/referrals/in-review/#{referral_id}")
    wait_for_spinner
  end

  def go_to_send_referral_with_id(referral_id:)
    get("/dashboard/referrals/sent/all/#{referral_id}")
    wait_for_spinner
  end

  def status
    text(REFERRAL_STATUS)
  end

  def current_referral_id
    uri = URI.parse(driver.current_url)
    uri.path.split('/').last
  end

  # ACCEPT
  def accept_action
    click(TAKE_ACTION_DROP_DOWN)
    click(TAKE_ACTION_ACCEPT_OPTION)
    is_displayed?(ACCEPT_MODAL)
    click(ACCEPT_PROGRAM_OPTIONS)
    click(ACCEPT_FIRST_PROGRAM_OPTION)
    click(ACCEPT_PRIMARY_WORKER_OPTIONS)
    click(ACCEPT_FIRST_PRIMARY_WORKER_OPTION)
    click(ACCEPT_SAVE_BTN)
    wait_for_spinner
  end

  # HOLD FOR REVIEW
  def hold_for_review_action(note:)
    click(TAKE_ACTION_DROP_DOWN)
    click(TAKE_ACTION_HOLD_OPTION)
    is_displayed?(HOLD_REFERRAL_MODAL)
    click(HOLD_REFERRAL_REASON_DROPDOWN)
    click(HOLD_REFERRAL_REASON_OPTION)
    enter(note, HOLD_REFERRAL_NOTE)
    click(HOLD_REFERRAL_BTN)
    wait_for_spinner
  end

  def go_to_sent_referral_with_id(referral_id:)
    get("/dashboard/referrals/sent/all/#{referral_id}")
  end

  # SEND
  def send_referral_action
    click(TAKE_ACTION_DROP_DOWN)
    click(TAKE_ACTION_SEND_OPTION)
  end

  def recipient_info
    text(RECIPIENT_INFO)
  end

  # DOCUMENTS
  def attach_document_to_referral(file_name:)
    click(DOCUMENT_ADD_LINK)
    is_displayed?(DOCUMENT_ATTACH_MODAL)
    local_file_path = create_consent_file(file_name)
    enter(local_file_path, DOCUMENT_FILE_INPUT)
    is_displayed?(DOCUMENT_PREVIEW)
    click(DOCUMENT_ATTACH_BTN)
    #deleting local file
    delete_consent_file(file_name)
  end

  def assessment_list
    text(ASSESSMENT_LIST)
  end

  def document_list
    text(DOCUMENT_LIST)
  end

  def no_documents?
    is_displayed?(DOCUMENT_EMPTY_LIST)
  end

  def open_assessment(assessment_name:)
    click(ASSESSMENT_LINK.transform_values { |v| v % assessment_name })
  end

  def page_displayed?
    wait_for_spinner
    is_displayed?(STATUS_TEXT) &&
    is_not_displayed?(TIMELINE_LOADING)
  end

  def remove_document_from_referral(file_name:)
    hover_over(DOCUMENT_LINK.transform_values { |v| v % file_name })
    click(DOCUMENT_REMOVE.transform_values { |v| v % file_name })
    is_displayed?(DOCUMENT_REMOVE_MODAL)
    click(DOCUMENT_REMOVE_BTN)
  end

end
