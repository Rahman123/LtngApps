/**
 * Keybopard Controller to deal with fetching and savnig keyboard shortcuts
 */
public with sharing class LA_KeyboardShortcuts_Controller extends ETLC_ApexBridge_Abstract {

    /**
     * Abstract method from ELC_ApexBridge class
     */
    public override void process(ETLC_ApexBridge_Data data) {
        if(data.debug) {
            Util.debug = data.debug;
        }

        Util.debug('LAKeyboardShortcuts_Controller:process():data BEFORE:' + data);
        // Depending on the mode, determine which operation to perform
        String mode = (String) data.getInputValue('mode');

        if (mode == 'fetchShortcuts') {
            data.output = ETLC_ApexBridge_Data.encodeData(fetchShortcuts());
        } else if (mode == 'saveShortcuts') {
            data.output = ETLC_ApexBridge_Data.encodeData(saveShortcuts((String)data.getInputValue('shortcutList')));
        }

        Util.debug('LAKeyboardShortcuts_Controller:process():data AFTER:' + data);
    }

    /**
     * Fetch shortcuts for current user who is logged in
     *
     * Return null if no settings
     *
     * @return LA_Keyboard__c
     */
    public LA_Info__c fetchShortcuts(){
        LA_Info__c lak = new LA_Info__c();

        try{
            lak = LADataQuery.getKeyboardShortcutsByUser(UserInfo.getUserId());
        }catch (SFDCAccessControlException e) { String message = 'Access Control violation - Type: ' + e.getExceptionType() + ' Reason: ' + e.getExceptionReason() + ' Object: ' + e.getExceptionObject() + ' Field: ' + e.getExceptionField() + ' Text: ' + e.getText(); Util.debug('LAKeyboardShortcuts_Controller.fetchShortcuts():SFDCAccessControlException: ' + message);
        }catch(Exception e){ Util.debug('LAKeyboardShortcuts_Controller.fetchShortcuts():Exception: ' + e.getMessage()); }


        Util.debug('LAKeyboardShortcuts_Controller.fetchShortcuts():lak: ' + lak);
        /**/
        return lak;
    }

    /**
     * Save shortcuts for current user; shortcuts will be overwritten so upsert is used
     *
     * @param String shortcutList JSON string of shortcuts to be saved for user
     *
     * @return LA_Keyboard__c
     */

    public LA_Info__c saveShortcuts(String shortcutList){
        LA_Info__c lak = new LA_Info__c();

        try{

            lak = LADataQuery.getKeyboardShortcutsByUser(UserInfo.getUserId());


            //If new record then set the name and user
            lak.Name = UserInfo.getUserId();
            lak.User__c = UserInfo.getUserId();

            //Always update shortcut even if record exists
            lak.Keyboard_Shortcuts__c = shortcutList;
            upsert lak;

        }catch (SFDCAccessControlException e) { String message = 'Access Control violation - Type: ' + e.getExceptionType() + ' Reason: ' + e.getExceptionReason() + ' Object: ' + e.getExceptionObject() + ' Field: ' + e.getExceptionField() + ' Text: ' + e.getText(); Util.debug('DWCreateOrder_Controller.getDWAccountList():SFDCAccessControlException: ' + message);
        }catch(Exception e){ Util.debug('LAKeyboard_Controller.saveShortcuts():Exception: ' + e.getMessage()); }


        Util.debug('LA_KeyboardShortcuts_Controller.fetchShortcuts():lak: ' + lak);

        return lak;
    }


}