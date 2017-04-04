({
    fetchShortcuts: function(component, helper){
        var apexBridge = component.find("ApexBridge");
        apexBridge.callApex({
            component: component,
            data: {
                operation: "LA_KeyboardShortcuts_Controller",
                input: {
                    mode: 'fetchShortcuts'
                }
            },
            callBackMethod: function (data) {
                //ltngappskeyboard
                var lak = data.output;
                component.find('utils').log('lak:', lak);
                component.set('v.keyboard', lak);

                var shortcuts, shortcutsMap = [];

                //If no keyboard shortcuts for the user then use the default ones specified
                //Otherwise use ones saved by user
                if($A.util.isUndefined(lak.ltngapps__Keyboard_Shortcuts__c) || lak.ltngapps__Keyboard_Shortcuts__c == null){

                    shortcuts = JSON.parse(component.get('v.shortcutsDefault'));
                }else{
                    shortcuts = JSON.parse(lak.ltngapps__Keyboard_Shortcuts__c);
                }


               for (var key in shortcuts) {
                   if(shortcuts[key] != false) {
                       shortcutsMap.push({value: shortcuts[key], keyCode: key, keyName: String.fromCharCode(key)});
                   }
               }

               component.find('utils').log('shortcuts:', shortcuts);
               component.find('utils').log('shortcutsMap:', shortcutsMap);

               component.set('v.shortcuts', shortcuts);
               component.set('v.shortcutsMap', shortcutsMap);
            }
        });
    }
})