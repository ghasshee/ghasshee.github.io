/*
 * return an array that holds the name list of enumerable own properties
 */
function keys(o) {
    if (typeof o !== "object") throw TypeError();
    var result = [];
    for (var prop in o) {
        if (o.hasOwnProperty(prop)) result.push(prop);
    }
    return result
}


var random = {
    get octet() {return Math.floor(Math.random()*256);},
    get uint16() {return Math.floor(Math.random()*65536);},
    get int16() {return Math.floor(Math.random()*65536)-32768;}
}


var p = {
    x: 1.0,
    y: 1.0,

    // r is read & writable
    get r() { return Math.sqrt(this.x*this.x + this.y*this.y)},
    set r(newvalue) {
        var oldvalue = Math.sqrt(this.x*this.x + this.y*this.y);
        var ratio = newvalue/oldvalue;
        this.x *= ratio;
        this.y *= ratio;
    },

    // theta is read-only
    get theta() {return Math.atan2(this.y, this.x);}
}





/* extend()
 * attached to All Object */

Object.defineProperty(Object.prototype, "extend", {
    writable: true,
    configurable: true,
    enumerable: false,
    value: function(o) {
        var names = Object.getOwnPropertyNames(o);
        for (var i=0; i < names.length; i++) {
            if (names[i] in this) continue;
            var desc = Object.getOwnPropertyDescriptor(o,names[i]);
            Object.defineProperty(this, names[i], desc);
        }
    }
});



/* return class attributes of an object*/

function classof(o) {
    if (o === null) return "Null";
    if (o === undefined) return "Undefined";
    return Object.prototype.toString.call(o).slice(8,-1);
}




function inherit(p) {
    if (p == null) throw TypeError();
    if (Object.create)
        return Object.create(p);
    var t = typeof p;
    if (t !== "object" && t !== "function") throw TypeError();
    function f() {};
    f.prototype = p;
    return new f();
}


Object.defineProperty(Object.prototype, "extend", {
    writable: true,
    configurable: true,
    enumerable: false,
    value: function(o) {
        var names = Object.getOwnPropertyNames(o);
        for (var i=0; i < names.length; i++) {
            if (names[i] in this) continue;
            var desc = Object.getOwnPropertyDescriptor(o,names[i]);
            Object.defineProperty(this, names[i], desc);
        }
    }
});
