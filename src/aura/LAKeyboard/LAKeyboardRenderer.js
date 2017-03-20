({
    rerender : function(component, helper) {
        var ret = this.superRerender();
        var altDown = false, shiftDown = false;

        document.onkeydown = function(e){
            //Option/Alt
            if (e.keyCode === 18) {
                altDown = true;
            } else if (e.keyCode === 16) {//Shift
                shiftDown = true;
            }

            var shortcuts = component.get('v.shortcuts');


            //Only if Alt + Shift + [A-Z0-9] AND if the pressed key is in the short cut list
            if(altDown && shiftDown && ((e.keyCode >=65 && e.keyCode <=90) || (e.KeyCode>=48 && e.keyCode<=57))
                    && typeof(shortcuts[e.keyCode]) != 'undefined' && (shortcuts[e.keyCode] != false)){
                component.find('utils').log('Key Down: Opt/Alt + Shift +  ' + String.fromCharCode(e.keyCode));

                var url = (typeof(shortcuts[e.keyCode]) != 'undefined')?shortcuts[e.keyCode]:'';

                if(url!= null && url != '') {
                    //Replace all slashes in front to avoid anyone using this for nefarious purposes
                    //Can NOT Encode URL variable otherwise it's not going to work.
                    url = '/' + url.replace(/^\/+/, '');

                    var urlEvent = $A.get("e.force:navigateToURL");

                    //Check if event is handled as in if you are in LEX or S!
                    if(typeof(urlEvent) != 'undefined') {
                        component.find('Redirect in LEX: ', url);

                        urlEvent.setParams({
                            "url": "/one/one.app#" + url
                        });
                        urlEvent.fire();
                    }else{
                        component.find('Redirect in Classic: ', url);
                        window.open(url);
                    }
                }

                altDown = false;
                shiftDown = false;
            }
            // esc
        };

        //return ret;
    },
})