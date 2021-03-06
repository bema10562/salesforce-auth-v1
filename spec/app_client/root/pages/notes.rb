# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class Notes < BasePage
  INTERACTION_TAB = { css: '#interactions-interaction-tab' }.freeze
  MESSAGE_TAB = { css: '#interactions-message-tab' }.freeze
  SERVICE_PROVIDED_TAB = { css: '#interactions-service-provided-tab' }.freeze
  OTHER_TAB = { css: '#interactions-other-tab' }.freeze
  PHI_INFO = { css: '.interactions .info-panel__text' }.freeze
  TEXT_BOX = { css: '#interactionNote' }.freeze
  POST_NOTE = { css: "[id$='-post-note-btn']" }.freeze
  SEND_MESSAGE_BUTTON = { css: '#new-note-post-note-btn' }.freeze
  ERROR_NO_CASE_SELECTED = { css: '.select-service-cases__error-message' }.freeze

  PHONE_INTERACTION = { css: '#phone_call-label' }.freeze
  EMAIL_INTERACTION = { css: '#email-label' }.freeze
  INPERSON_INTERACTION = { css: '#meeting-label' }.freeze
  DURATION_DROPDOWN = { css: "div[aria-activedescendant='choices-interactionDuration-item-choice-1'] > .choices__inner" }.freeze
  DURATION_OPTIONS = { css: ".choices__list > div[data-value='%s']" }.freeze
  DURATIONS = { '15m' => '15', '> 2h 30m' => '999999' }.freeze

  MESSAGE_BOX = { css: '.message' }.freeze
  MESSAGE_INFO = { css: '.message-enabled-communication-text' }.freeze
  MESSAGE_FIELD = { css: '#message-field' }.freeze

  SERVICE_PROVIDED = { css: '#providedServiceType' }.freeze
  SERVICE_PROVIDED_AMOUNT = { css: '#providedServiceAmount' }.freeze
  SERVICE_PROVIDED_UNIT_DROPDOWN = { css: '#providedServiceUnit + div' }.freeze
  SERVICE_PROVIDED_UNIT_DOLLAR = { css: '#choices-providedServiceUnit-item-choice-1' }.freeze
  SERVICE_PROVIDED_POST_BTN = { css: '#track-service-post-note-btn' }.freeze

  ATTACHED_TO_CASE_RADIO = { css: '#case-label' }.freeze
  ADD_TO_CASE_SELECTIONS = { css: '.select-service-cases:not(.hidden)' }.freeze
  CASE_CHECK_BOX = { css: 'label[for="case-0-checkbox"]' }.freeze

  PHI_NOTE = 'Only include personally identifiable information (PII), protected health information (PHI), or other sensitive information if it is necessary to provide services to the client.'

  def click_type_of_note(type:)
    case type
    when 'Interaction'
      click(INTERACTION_TAB)
    when 'Message'
      click(MESSAGE_TAB)
    when 'Service'
      click(SERVICE_PROVIDED_TAB)
    when 'Other'
      click(OTHER_TAB)
    end
  end

  def add_interaction(note)
    case note[:type]
    when 'Phone Call'
      click(PHONE_INTERACTION)
      click(DURATION_DROPDOWN)
      click(DURATION_OPTIONS.transform_values { |v| v % DURATIONS[note[:duration]] })
    when 'Email'
      click(EMAIL_INTERACTION)
    when 'Meeting'
      click(INPERSON_INTERACTION)
      click(DURATION_DROPDOWN)
      click(DURATION_OPTIONS.transform_values { |v| v % DURATIONS[note[:duration]] })
    end

    raise StandardError, 'PHI warning not displayed' unless text(PHI_INFO) == PHI_NOTE

    enter(note[:content], TEXT_BOX)
    click(POST_NOTE)
  end

  def add_note_to_case_displayed?
    is_displayed?(ADD_TO_CASE_SELECTIONS)
  end

  def case_detail_notes_section_displayed?
    is_displayed?(INTERACTION_TAB) &&
      is_displayed?(SERVICE_PROVIDED_TAB) &&
      is_displayed?(OTHER_TAB)
  end

  def send_message_to_client(method:, note:)
    click_type_of_note(type: 'Message')
    message_content = text(MESSAGE_INFO)
    raise StandardError, "#{message_content} did not contain #{method}" unless message_content.include?(method)

    enter(note, MESSAGE_FIELD)
    click(SEND_MESSAGE_BUTTON)
  end

  def add_service_provided_note(note)
    enter_service_provided_note(note)
    post_note
  end

  def enter_service_provided_note(note)
    click_type_of_note(type: 'Service')
    enter(note[:service], SERVICE_PROVIDED)
    enter(note[:amount], SERVICE_PROVIDED_AMOUNT)
    click(SERVICE_PROVIDED_UNIT_DROPDOWN)
    click(SERVICE_PROVIDED_UNIT_DOLLAR)

    raise StandardError, 'PHI warning not displayed' unless text(PHI_INFO) == PHI_NOTE

    enter(note[:content], TEXT_BOX)
  end

  def add_service_provided_to_first_case(note)
    raise StandardError, 'Cases not displayed' unless is_displayed?(ADD_TO_CASE_SELECTIONS)

    enter_service_provided_note(note)
    click(CASE_CHECK_BOX)
    click(POST_NOTE)
    is_not_displayed?(ERROR_NO_CASE_SELECTED)
  end

  def enter_other_note(note)
    click_type_of_note(type: 'Other')
    raise StandardError, 'PHI warning not displayed' unless text(PHI_INFO) == PHI_NOTE

    enter(note[:content], TEXT_BOX)
  end

  def add_other_note_to_first_case(note)
    raise StandardError, 'Cases not displayed' unless is_displayed?(ADD_TO_CASE_SELECTIONS)

    enter_other_note(note)
    click(CASE_CHECK_BOX)
    click(POST_NOTE)
    is_not_displayed?(ERROR_NO_CASE_SELECTED)
  end

  def post_note
    click(POST_NOTE)
  end
end
