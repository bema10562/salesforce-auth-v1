require_relative '../../../shared_components/base_page'
require_relative '../../../../lib/File_helper'

class Uploads < BasePage 
        
    UPLOAD_DOCUMENT = { css: '#upload-document-btn' }
    DOCUMENT_UPLOAD_MODEL = { css: '.upload-and-attach-documents-form-fields' }
    DOCUMENT_UPLOAD_CONTEXT = { css: '#upload-document-modal' }
    DOCUMENT_UPLOAD_INPUT = { css: 'input[type="file"]' }
    DOCUMENT_PREVIEW = { css: '.preview-item' }
    DOCUMENT_ATTATCH_BUTTON  = { css: '#upload-submit-btn'}

    DOCUMENT_NAME = { xpath: ".//p[text()='%s']"}
    DOCUMENT_NAME_LIST = { css: ".contact-document-card-menu__title" }
    DOCUMENT_MENU = { xpath: ".//p[text()='%s']/following-sibling::div" }   
    DOCUMENT_MENU_RENAME = { css: '#document-menu-item-rename' }
    DOCUMENT_MENU_REMOVE = { css: '#document-menu-item-remove'}

    DIALOG = { css: '.dialog-paper'}
    RENAME_TEXT_FIELD = { css: '#rename-document-title-field'}
    SAVE_BUTTON = { css: 'button[aria-label="Save"]'}
    REMOVE_BUTTON = { css: 'button[aria-label="Remove"]'}

    def page_displayed?
        is_displayed?(UPLOAD_DOCUMENT)
        wait_for_spinner
    end

    def upload_document(file_name)
        #creating a local file with an identifiable name
        local_file_path = create_consent_file(file_name)
        #opening upload dialog
        click(UPLOAD_DOCUMENT)
        is_displayed?(DOCUMENT_UPLOAD_MODEL)
        enter_within(local_file_path, DOCUMENT_UPLOAD_CONTEXT, DOCUMENT_UPLOAD_INPUT)
        is_displayed?(DOCUMENT_PREVIEW)
        click(DOCUMENT_ATTATCH_BUTTON)
        #deleting local file
        delete_consent_file(file_name)
        #new file displays
        is_displayed?(DOCUMENT_NAME.transform_values{|v| v % file_name})
    end

    def rename_document(current_file_name:, new_file_name:)
        #opening specified document menu
        click(DOCUMENT_MENU.transform_values{|v| v % current_file_name})
        #opening rename dialog 
        click_within(DOCUMENT_MENU.transform_values{|v| v % current_file_name}, DOCUMENT_MENU_RENAME)
        is_displayed?(DIALOG)
        clear(RENAME_TEXT_FIELD)
        enter(new_file_name, RENAME_TEXT_FIELD)
        click(SAVE_BUTTON)
        #new file name displays
        is_displayed?(DOCUMENT_NAME.transform_values{|v| v % new_file_name})
    end

    def remove_document(file_name)
        #opening specified document menu
        click(DOCUMENT_MENU.transform_values{|v| v % file_name})
        #opening remove dialog 
        click_within(DOCUMENT_MENU.transform_values{|v| v % file_name}, DOCUMENT_MENU_REMOVE)
        is_displayed?(DIALOG)
        click(REMOVE_BUTTON)
        #file no longer displays
        is_not_displayed?(DOCUMENT_NAME.transform_values{|v| v % file_name}, 5)
    end            
    
    #for clean up purposes deleting all documents created during test cases
    def delete_documents
        find_elements(DOCUMENT_NAME_LIST).each do |document|
            remove_document(document.text)
        end 
    end
end  
