@IsTest
private class LA_KeyboardShortcuts_Controller_Test {

    private static Profile p;
    private static User u;


    //NOT using @testSetup because need to manually insert data
    private static void setupData(){
        List<LA_Info__c> lakList = new List<LA_Info__c>();
        for(Integer i=0; i<210; i++){
            LA_Info__c lak = new LA_Info__c();
            lak.Name = 'Name ' + i;
            lakList.add(lak);
        }
        insert lakList;
    }


    private static void dataSetupForRunAs(){
        p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='user@test.ltngapps');
    }

    private static testMethod void saveShortcuts_negative() {
        Util.debug = true;

        Map<String, Object> data = new Map<String, Object>{
                'mode'=>'saveShortcuts',
                'shortcutList' => '{}'
        };


        Test.startTest();

        ETLC_ApexBridge_Data d1 = new ETLC_ApexBridge_Data();
        d1.operation = 'LA_KeyboardShortcuts_Controller';
        d1.input = ETLC_ApexBridge_Data.encodeData(data);
        d1.debug = true;

        String strD2 =  ETLC_ApexBridge_Controller.execute(d1.toJson());
        ETLC_ApexBridge_Data d2 = ETLC_ApexBridge_Data.fromJSON(strD2);

        Test.stopTest();
        LA_Info__c lak = [SELECT ID, Name, User__c, Keyboard_Shortcuts__c from LA_Info__c where User__c=:Userinfo.getUserId() LIMIT  1];

        LA_Info__c retVal = (LA_Info__c)ETLC_ApexBridge_Data.decodeData(d2.output, LA_Info__c.class);

        System.assertEquals(lak.ID, retVal.ID);
    }

    
    private static testMethod void fetchShortcuts_negative() {

        Map<String, Object> data = new Map<String, Object>{
                'mode'=>'fetchShortcuts'
        };


        Test.startTest();

        ETLC_ApexBridge_Data d1 = new ETLC_ApexBridge_Data();
        d1.operation = 'LA_KeyboardShortcuts_Controller';
        d1.input = ETLC_ApexBridge_Data.encodeData(data);
        d1.debug = true;

        String strD2 =  ETLC_ApexBridge_Controller.execute(d1.toJson());
        ETLC_ApexBridge_Data d2 = ETLC_ApexBridge_Data.fromJSON(strD2);

        Test.stopTest();

        LA_Info__c retVal = (LA_Info__c)ETLC_ApexBridge_Data.decodeData(d2.output, LA_Info__c.class);

        System.assertEquals(null, retVal.ID);
    }


    private static testMethod void fetchShortcuts_positive() {
        setupData();

        LA_Info__c lak = [select id from LA_Info__c limit 1];
        lak.User__c = Userinfo.getUserId();
        upsert lak;

        Map<String, Object> data = new Map<String, Object>{
                'mode'=>'fetchShortcuts'
        };


        Test.startTest();

        ETLC_ApexBridge_Data d1 = new ETLC_ApexBridge_Data();
        d1.operation = 'LA_KeyboardShortcuts_Controller';
        d1.input = ETLC_ApexBridge_Data.encodeData(data);
        d1.debug = true;

        String strD2 =  ETLC_ApexBridge_Controller.execute(d1.toJson());
        ETLC_ApexBridge_Data d2 = ETLC_ApexBridge_Data.fromJSON(strD2);

        Test.stopTest();

        LA_Info__c retVal = (LA_Info__c)ETLC_ApexBridge_Data.decodeData(d2.output, LA_Info__c.class);

        System.assertEquals(lak.ID, retVal.ID);
    }



    private static testMethod void saveShortcuts_runas() {
        setupData();
        dataSetupForRunAs();

        System.runAs(u) {

            LA_Info__c lak = [select id, Name, Keyboard_Shortcuts__c from LA_Info__c limit 1];
            System.assertEquals(null, lak.Keyboard_Shortcuts__c);

            Map<String, Object> data = new Map<String, Object>{
                    'mode' => 'saveShortcuts',
                    'shortcutList' => '{}'
            };

            Test.startTest();

            ETLC_ApexBridge_Data d1 = new ETLC_ApexBridge_Data();
            d1.operation = 'LA_KeyboardShortcuts_Controller';
            d1.input = ETLC_ApexBridge_Data.encodeData(data);
            d1.debug = true;

            String strD2 = ETLC_ApexBridge_Controller.execute(d1.toJson());
            ETLC_ApexBridge_Data d2 = ETLC_ApexBridge_Data.fromJSON(strD2);

            Test.stopTest();

            LA_Info__c retVal = (LA_Info__c) ETLC_ApexBridge_Data.decodeData(d2.output, LA_Info__c.class);

            System.assertEquals(null, retVal.Keyboard_Shortcuts__c);
        }
    }
    private static testMethod void fetchShortcuts_runas() {
        setupData();
        dataSetupForRunAs();

        System.runAs(u) {

            LA_Info__c lak = [select id from LA_Info__c limit 1];

            Map<String, Object> data = new Map<String, Object>{
                    'mode' => 'fetchShortcuts'
            };


            Test.startTest();

            ETLC_ApexBridge_Data d1 = new ETLC_ApexBridge_Data();
            d1.operation = 'LA_KeyboardShortcuts_Controller';
            d1.input = ETLC_ApexBridge_Data.encodeData(data);
            d1.debug = true;

            String strD2 = ETLC_ApexBridge_Controller.execute(d1.toJson());
            ETLC_ApexBridge_Data d2 = ETLC_ApexBridge_Data.fromJSON(strD2);

            Test.stopTest();

            LA_Info__c retVal = (LA_Info__c) ETLC_ApexBridge_Data.decodeData(d2.output, LA_Info__c.class);

            //test should pass for system admin but not as standard user because it doesn't have permission to this new object
            System.assertEquals(null, retVal.ID);
        }
    }

    private static testMethod void saveShortcuts_positive() {
        setupData();

        LA_Info__c lak = [select id, Keyboard_Shortcuts__c from LA_Info__c limit 1];
        System.assertEquals(null, lak.Keyboard_Shortcuts__c);


        Map<String, Object> data = new Map<String, Object>{
                'mode'=>'saveShortcuts',
                'shortcutList' => '{}'
        };

        Test.startTest();

        ETLC_ApexBridge_Data d1 = new ETLC_ApexBridge_Data();
        d1.operation = 'LA_KeyboardShortcuts_Controller';
        d1.input = ETLC_ApexBridge_Data.encodeData(data);
        d1.debug = true;

        String strD2 =  ETLC_ApexBridge_Controller.execute(d1.toJson());
        ETLC_ApexBridge_Data d2 = ETLC_ApexBridge_Data.fromJSON(strD2);

        Test.stopTest();

        LA_Info__c retVal = (LA_Info__c)ETLC_ApexBridge_Data.decodeData(d2.output, LA_Info__c.class);

        System.assertEquals('{}', retVal.Keyboard_Shortcuts__c);
    }




    /**/
}