({
    addShortcut: function(component, event, helper){
        helper.addShortcut(component, helper);
    },
    getUrlHash: function(component, event, helper) {
        var hash = window.location.hash.substr(1);
        component.find('path').set('v.value', hash);
    },
    getUrlHashWithQueryParam: function(component, event, helper) {
        var hash = window.location.hash;
        //remove any part after ? from hash
        hash = hash.substring(hash.lastIndexOf("#")+1,hash.lastIndexOf("?"));
        component.find('path').set('v.value', hash);
    }
})