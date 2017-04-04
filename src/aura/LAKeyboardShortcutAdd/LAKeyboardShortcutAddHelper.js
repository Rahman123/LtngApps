({
    isValid: function(component, helper){

       //var key = component.get('v.key');

        var message = Array();
        var path = component.find('path');
        var keySelected = component.find('keySelected');


        if ((path.get('v.validity') != null && ( !path.get('v.validity').valid || path.get('v.validity').valueMissing)) || $A.util.isEmpty(path.get('v.value'))) {
            message.push(
                ["markup://ui:message", {
                    'severity': 'error',
                    'body': 'Please enter path to map',
                    'closable': true
                }]
            );
        }


        if((keySelected.get('v.validity') != null && (!keySelected.get('v.validity').valid ||  keySelected.get('v.validity').valueMissing)) || $A.util.isEmpty(keySelected.get('v.value'))){
            message.push(
                ["markup://ui:message", {
                    'severity': 'error',
                    'body': 'Please enter a key in proper format',
                    'closable': true
                }]
            );
        }
        if(message.length > 0) {
            component.find('utils').createComponents(message, component.find('uiMessage'));
            return false;
        }else{
            component.find('utils').destroyComponents(component.find('uiMessage'));
            return true;
        }
    },
    addShortcut: function(component, helper){
        if(helper.isValid(component, helper)) {

            var key = component.find('keySelected');
            var keyName = key.get('v.value').toUpperCase();
            var keyCode = keyName.charCodeAt(keyName.length-1);

            var path = component.find('path').get('v.value');


            var shortcuts = component.get('v.shortcuts');
            if (shortcuts == null) {
                shortcuts = {};
            }

            shortcuts[keyCode] = path;

            var apexBridge = component.find("ApexBridge");
            apexBridge.callApex({
                component: component,
                data: {
                    operation: "LA_KeyboardShortcuts_Controller",
                    input: {
                        mode: 'saveShortcuts',
                        shortcutList: JSON.stringify(shortcuts)
                    }
                },
                callBackMethod: function (data) {
                    var lak = data.output;
                    var message = Array();

                    if ($A.util.isUndefined(lak.ltngapps__Keyboard_Shortcuts__c) || lak.ltngapps__Keyboard_Shortcuts__c == null) {
                        message.push(
                            ["markup://ui:message", {
                                'severity': 'error',
                                'body': 'Some error occured while adding keyboard shortcut',
                                'closable': true
                            }]
                        );

                    } else {
                        message.push(
                            ["markup://ui:message", {
                                'severity': 'success',
                                'body': 'Shortcut was added successfully',
                                'closable': true
                            }]
                        );
                        //Update the attribute so that it can trickle up to parent component
                        component.set('v.shortcuts', shortcuts);
                        var shortcutsMap = [];
                        for (var key in shortcuts) {
                            //Using false method because "delete"ing a key is not available in Spring'17
                            if (shortcuts[key] != false) {
                                shortcutsMap.push({
                                    value: shortcuts[key],
                                    keyName: String.fromCharCode(key),
                                    keyCode: key
                                });
                            }
                        }

                        component.set('v.shortcutsMap', shortcutsMap);
                    }
                    if (message.length > 0) {
                        //Create new components through utility method
                        component.find('utils').createComponents(message, component.find('uiMessage'));
                    }
                }
            });
        }
    }
})