contract DSSigHelperMixin {
    // TODO do this more idiomatically
    function dyn_sig() internal returns (bytes4) {
        uint sig = 0;
        var zero = uint(msg.data[0]);
        sig += zero * 256**3;
        var one = uint(msg.data[1]);
        sig += one * 256**2;
        var two = uint(msg.data[2]);
        sig += two * 256**1;
        var three = uint(msg.data[3]);
        sig += three * 256**0;
        return bytes4(sig);
    }
    modifier printsig() {
        sig(msg.sig);
        _
    }
    event sig(bytes4 sig);
}

// Add a function, add the S() modifier, and run the tests to see
// any function's signature.
// Also used to test get_my_sig implementation, needed to get the
// sig when you are in a fallback function.
contract SigHelper is DSSigHelperMixin {
    bytes4 public last_sig;
    bytes4 public internal_helper_sig;
    modifier S() {
        last_sig = msg.sig;
        _
    }
    function internal_tester() internal returns (bytes4 sig) {
        return msg.sig;
    }
    //0x73b4fbd7
    function assets(bytes8 symbol) S() returns (address) {
        internal_helper_sig = internal_tester();
    }
    function poke() S() {}
    function breach() S() {}
    function look() S() returns (uint) {}

    // testing a few other things
    function get_my_sig() S() returns (bytes4) {
        return dyn_sig();
    }
    function() {
        last_sig = msg.sig; // 0x0
    }
}
