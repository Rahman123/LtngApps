({
    render : function(component, helper) {
        var ret = this.superRender();


        /*
        var altDown = false, shiftDown = false;

        document.onkeydown = function(e){
            //Option/Alt
            if (e.keyCode === 18) {
                altDown = true;
            } else if (e.keyCode === 16) {//Shift
                shiftDown = true;
            }
            if(altDown && shiftDown && ((e.keyCode >=65 && e.keyCode <=90) || (e.KeyCode>=48 && e.keyCode<=57))){
                component.find('utils').log('Key Down (ADD): Opt/Alt + Shift +  ', String.fromCharCode(e.keyCode));

                //Only A-Z or 0-9

                component.find('keyDown').set('v.value', String.fromCharCode(e.keyCode));
                component.set('v.key', e);
            
                altDown = false;
                shiftDown = false;

            }
            // esc
        };
        */

        /**/
        return ret;
        /**/
    },
})