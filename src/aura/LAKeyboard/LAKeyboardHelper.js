({
    fetchShortcuts: function(component, helper){
        var apexBridge = component.find("ApexBridge");
        apexBridge.callApex({
            component: component,
            data: {
                operation: "LAKeyboard_Controller",
                input: {
                    mode: 'fetchShortcuts'
                }
            },
            callBackMethod: function (data) {
                //ltngappskeyboard
                var lak = data.output;

                var message = Array();

               if($A.util.isUndefined(lak.ltngapps__Shortcuts__c) || lak.ltngapps__Shortcuts__c == null){
                   message.push(
                       ["ui:message", {
                           'severity': 'error',
                           'body': 'No keyboard shortcuts available'
                       }]
                   );

               }else{
                   component.find('utils').log('lak:', lak);
                   component.set('v.keyboard', lak);

                   var shortcuts = JSON.parse(lak.ltngapps__Shortcuts__c);
                   var shortcutsMap = [];
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
               if(message.length > 0) {
                   //Create new components through utility method
                   component.find('utils').createComponents(message, component.find('fetchUiMessage'));
               }
            }
        });
    }
})