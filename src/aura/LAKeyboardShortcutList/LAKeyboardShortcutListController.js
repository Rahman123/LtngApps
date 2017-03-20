({
    removeShortcut: function(component, event, helper){
        helper.removeShortcut(component, helper, event.getSource().get('v.value'));
    }
})