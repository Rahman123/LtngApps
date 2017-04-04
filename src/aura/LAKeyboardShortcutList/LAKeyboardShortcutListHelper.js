/**
 * Created by jrattanpal on 3/4/17.
 */
({
    removeShortcut: function(component, helper, keyToRemove){
        component.find('utils').log('keyToRemove:', keyToRemove);
        var shortcuts = component.get('v.shortcuts');

        component.find('utils').log('shortcuts:', shortcuts);
        if(typeof(shortcuts[keyToRemove]) != 'undefined'){
            //Using false method because "delete"ing a key is not available in Spring'17
            //TODO: change to "delete" in Summer'17
            shortcuts[keyToRemove] = false;
        }

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

                if($A.util.isUndefined(lak.ltngapps__Keyboard_Shortcuts__c) || lak.ltngapps__Keyboard_Shortcuts__c == null){
                    message.push(
                        ["markup://ui:message", {
                            'severity': 'error',
                            'body': 'Some error occured while removing keyboard shortcut',
                            'closable': true
                        }]
                    );

                }else{
                    message.push(
                        ["markup://ui:message", {
                            'severity': 'success',
                            'body': 'Shortcut was removed successfully',
                            'closable': true
                        }]
                    );
                    //Update the attribute so that it can trickle up to parent component
                    component.set('v.shortcuts', shortcuts);
                    var shortcutsMap = [];
                    for (var key in shortcuts) {
                        //Using false method because "delete"ing a key is not available in Spring'17
                        if(shortcuts[key] != false) {
                            shortcutsMap.push({value: shortcuts[key], keyCode: key, keyName: String.fromCharCode(key)});
                        }
                    }

                    component.set('v.shortcutsMap', shortcutsMap);
                }
                if(message.length > 0) {
                    console.log('test:', message);
                    console.log('uiMessage:', component.find('uiMessage'));
                    //Create new components through utility method
                    component.find('utils').createComponents(message, component.find('uiMessage'));
                }
            }
        });
    }
})