/**
 * Keybopard Controller to deal with fetching and savnig keyboard shortcuts
 */
public with sharing class LAKeyboard_Controller extends ETLC_ApexBridge_Abstract {

    private Boolean debugFlag;
    private static Profile p;
    private static User u;
    /**
     * Central place to debug logs
     */
    private void debug(Object message){
        If(debugFlag)   {
            System.debug(message);
        }
    }

    /**
     * Abstract method from ELC_ApexBridge class
     */
    public override void process(ETLC_ApexBridge_Data data) {
        this.debugFlag = data.debug;

       debug('data BEFORE:' + data);
        // Depending on the mode, determine which operation to perform
        String mode = (String) data.getInputValue('mode');

        if (mode == 'fetchShortcuts') {
            data.output = ETLC_ApexBridge_Data.encodeData(fetchShortcuts());
        } else if (mode == 'saveShortcuts') {
            data.output = ETLC_ApexBridge_Data.encodeData(saveShortcuts((String)data.getInputValue('shortcutList')));
        }

        debug('data AFTER:' + data);
    }

    /**
     * Fetch shortcuts for current user who is logged in
     *
     * Return null if no settings
     *
     * @return LA_Keyboard__c
     */
    public LA_Keyboard__c fetchShortcuts(){
        LA_Keyboard__c lak = new LA_Keyboard__c();
        try{
            //CRUD/FLS check
            Util.AccessController.assertAuthorizedToView(
                    Schema.LA_Keyboard__c.getSobjectType(),
                    new List<Schema.SobjectField>{
                            Schema.LA_Keyboard__c.fields.Name, Schema.LA_Keyboard__c.fields.User__c,
                            Schema.LA_Keyboard__c.fields.Shortcuts__c
                    }
            );

            List<LA_Keyboard__c> lakList = [SELECT ID, Name, User__c, Shortcuts__c from LA_Keyboard__c where User__c=:Userinfo.getUserId() LIMIT  1];
            debug('LAKeyboard_Controller.fetchShortcuts():lakList: ' + lakList);
            if(lakList.size() > 0 ){
                lak = lakList[0];
            }
        }catch (SFDCAccessControlException e) { String message = 'Access Control violation - Type: ' + e.getExceptionType() + ' Reason: ' + e.getExceptionReason() + ' Object: ' + e.getExceptionObject() + ' Field: ' + e.getExceptionField() + ' Text: ' + e.getText();debug('DWCreateOrder_Controller.getDWAccountList():SFDCAccessControlException: ' + message);
        }catch(Exception e){ Util.log('LAKeyboard_Controller.fetchShortcuts():Exception: ' + e.getMessage()); }


        debug('LAKeyboard_Controller.fetchShortcuts():lak: ' + lak);
        return lak;
    }

    /**
     * Save shortcuts for current user; shortcuts will be overwritten so upsert is used
     *
     * @param String shortcutList JSON string of shortcuts to be saved for user
     *
     * @return LA_Keyboard__c
     */

    public LA_Keyboard__c saveShortcuts(String shortcutList){
        LA_Keyboard__c lak = new LA_Keyboard__c();
        try{

            //CRUD/FLS check for UPSERT (i.e. Update/Create)

            Util.AccessController.assertAuthorizedToUpdate(
                    Schema.LA_Keyboard__c.getSobjectType(),
                    new List<Schema.SobjectField>{
                            Schema.LA_Keyboard__c.fields.Name, Schema.LA_Keyboard__c.fields.User__c,
                            Schema.LA_Keyboard__c.fields.Shortcuts__c
                    }
            );
            //CRUD/FLS check
            Util.AccessController.assertAuthorizedToCreate(
                    Schema.LA_Keyboard__c.getSobjectType(),
                    new List<Schema.SobjectField>{
                            Schema.LA_Keyboard__c.fields.Name, Schema.LA_Keyboard__c.fields.User__c,
                            Schema.LA_Keyboard__c.fields.Shortcuts__c
                    }
            );

            //Let's do a SOQL to get ID to make sure it's correct record
            List<LA_Keyboard__c> lakList = [SELECT ID, Name, User__c, Shortcuts__c from LA_Keyboard__c where User__c=:Userinfo.getUserId() LIMIT  1];
            //If a record exists then use that other wise create a new one
            if(lakList.size() > 0 ){
                lak.Id = lakList[0].Id;
            }else{
                //If new record then set the name and user
                lak.Name = UserInfo.getUserId();
                lak.User__c = UserInfo.getUserId();
            }
            //Always update shortcut even if record exists
            lak.Shortcuts__c = shortcutList;
            upsert lak;

        }catch (SFDCAccessControlException e) { String message = 'Access Control violation - Type: ' + e.getExceptionType() + ' Reason: ' + e.getExceptionReason() + ' Object: ' + e.getExceptionObject() + ' Field: ' + e.getExceptionField() + ' Text: ' + e.getText();debug('DWCreateOrder_Controller.getDWAccountList():SFDCAccessControlException: ' + message);
        }catch(Exception e){ Util.log('LAKeyboard_Controller.saveShortcuts():Exception: ' + e.getMessage()); }


        debug('LAKeyboard_Controller.fetchShortcuts():lak: ' + lak);
        return lak;
    }


}