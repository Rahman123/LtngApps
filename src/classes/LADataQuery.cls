/**
 * Data Query class to have all the SOQL queries here along with CRUD/FLS
 */
public with sharing class LADataQuery {
    /**
     * Return keyboard shortcuts for User ID
     * Caution: make sure to wrap this code in try/catch
     *
     * SFDCAccessControlException should be handled for CRUD/FLS exception
     */
    public static LA_Info__c getKeyboardShortcutsByUser(Id UserID) {
        LA_Info__c retValue = new LA_Info__c();

        //CRUD/FLS check
        Util.AccessController.assertAuthorizedToView(
                Schema.LA_Keyboard__c.getSobjectType(),
                new List<Schema.SobjectField>{
                        Schema.LA_Keyboard__c.fields.Name, Schema.LA_Keyboard__c.fields.User__c,
                        Schema.LA_Keyboard__c.fields.Shortcuts__c
                }
        ); 

        List<LA_Info__c> lakList = [SELECT ID, Name, User__c, Keyboard_Shortcuts__c from LA_Info__c where User__c=:Userinfo.getUserId() LIMIT  1];

        Util.debug('LADataQuery.getKeyboardShortcutsByUser():lakList: ' + lakList);

        if(lakList.size() > 0 ){
            retValue = lakList[0];
        }
        return retValue;
    }
}