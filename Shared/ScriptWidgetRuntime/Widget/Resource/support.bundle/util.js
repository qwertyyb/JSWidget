
class ScriptWidget {
    static createElement(tag, props, ...children) {
        return $element.createElement(tag, props, children);
    }
    
    /*
     short syntax for
     <>
         <text>1</text>
         <text>1</text>
     </>
     
     */
    static Fragment = "Fragment"
}

function $json(obj) {
    return JSON.stringify(obj)
}

function $type_of_object(obj) {
    return typeof obj
}
