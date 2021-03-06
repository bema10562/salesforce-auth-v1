# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class Network < BasePage
  EMPTY_SEARCH_FILTER = { css: '#search-query-disabled' }
  FILTERS_BTN = { css: '#more-filters-btn' }
  DRAWER_OPEN = { css: '.ui-drawer.ui-drawer--secondary.ui-drawer--opened' }
  LOADER = { css: '.loader' }
  PROGRAM_CARD = { css: '.network-program-card' }
  PROGRAM_CARD_ADD_BTN = { css: '.network-program-card div a' }
  PROGRAM_NAME = { css: '.program-name' }
  PROVIDER_NAME = { css: '.text-sm.text-blue-dark' }
  RESULT_DIV = { css: '.ui-drawer-with-header + div' }
  SELECTED_PROGRAMS_COUNT = { css: '.selected-programs-count' }
  SERVICE_TYPE_FILTER = { css: '#service-types-all-filter' }
  SERVICE_TYPE_OPTION = { css: '.ui-filter-option.level-1' }
  SEARCH_FILTER = { css: '#search-query' }
  SHARE_BTN = { id: 'share-programs-btn' }

  def add_first_program
    add_programs_by_index([0])
  end

  def add_programs_by_index(index_arr)
    add_btns = find_elements(PROGRAM_CARD_ADD_BTN)
    index_arr.each do |i|
      add_btns[i].click
    end
  end

  def click_first_program_card
    nth_program_card(0).click
  end

  def click_share
    click_via_js(SHARE_BTN)
  end

  def drawer_open?
    is_present?(DRAWER_OPEN)
  end

  def drawer_closed?
    !is_present?(DRAWER_OPEN)
  end

  def first_program_name
    nth_program_name(0)
  end

  def second_program_name
    nth_program_name(1)
  end

  def first_provider_name
    nth_provider_name(0)
  end

  def second_provider_name
    nth_provider_name(1)
  end

  def open_filter_drawer
    click(FILTERS_BTN)
  end

  def page_displayed?
    is_displayed?(SERVICE_TYPE_FILTER) &&
      is_displayed?(EMPTY_SEARCH_FILTER)
      is_not_displayed?(LOADER)
  end

  def search_by_text(text:)
    enter_and_return(text, EMPTY_SEARCH_FILTER)

    # wait for results to update:
    is_not_displayed?(LOADER)
  end

  def search_result_text
    is_not_displayed?(LOADER) &&
      text(RESULT_DIV)
  end

  def select_service_type(service_type)
    click(SERVICE_TYPE_FILTER)
    click_element_from_list_by_text(SERVICE_TYPE_OPTION, service_type)
  end

  def selected_programs_count_text
    text(SELECTED_PROGRAMS_COUNT)
  end

  private
  def program_cards
    find_elements(PROGRAM_CARD)
  end

  def nth_program_card(index)
    program_cards[index]
  end

  def nth_program_name(index)
    nth_program_card(index).find_element(PROGRAM_NAME).text
  end

  def nth_provider_name(index)
    nth_program_card(index).find_element(PROVIDER_NAME).text
  end
end
