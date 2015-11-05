import 'dapple/debug.sol';

contract Tester {
	address _t;
	function _target( address target ) {
		_t = target;
	}
	function() {
		_t.call(msg.data);
	}
}

contract Test is Debug {
    bytes32 testname;
    address me;
    // easy way to detect if its a test from the abi
    bool public IS_TEST;
    bool public failed;
    function Test() {
        me = address(this);
        IS_TEST = true;
    }

    modifier tests(bytes32 what) {
        _
    }
    function fail() {
        failed = true;
    }
    function assertTrue(bool what) {
        if( !what ) {
            logs("assertTrue was false");
            fail();
        }
    }
    function assertTrue(bool what, bytes32 error) {
        if( !what ) {
            logs("assertTrue was false");
            log_bytes32(error);
            fail();
        }
    }
    function assertFalse(bool what) {
        if( what ) {
            logs("assertFalse was true");
            fail();
        }
    }
    function assertFalse(bool what, bytes32 error) {
        if( what ) {
            logs("assertFalse was true");
            log_bytes32(error);
            fail();
        }
    }
    function assertEq0(bytes a, bytes b) {
        var len = a.length;
        var ok = true;
        if( b.length == len ) {
            for( var i = 0; i < len; i++ ) {
                if( a[i] != b[i] ) {
                    ok = false;
                }
            }
        } else {
            ok = false;
        }
        if( !ok ) {
            log_bytes32("failed assertEq(bytes)");
            fail();
        }
    }
    function assertEq0(bytes a, bytes b, bytes32 err) {
        var len = a.length;
        var ok = true;
        if( b.length == len ) {
            for( var i = 0; i < len; i++ ) {
                if( a[i] != b[i] ) {
                    ok = false;
                }
            }
        } else {
            ok = false;
        }
        if( !ok ) {
            log_bytes32("failed assertEq(bytes)");
            log_bytes32(err);
            fail();
        }
    }


    /*[[[cog
    import cog
    types = ['bool', 'uint', 'int', 'address']
    for i in range(32):
        types.append('bytes'+str(i+1))
    for type in types:
        fname = "assertEq"
        if type.startswith("bytes") and type != "bytes":
            fname += type.strip("bytes")
        cog.out("function " + fname + "(")
        cog.outl(type + " a, " + type + " b, bytes32 err) {")
        cog.outl("    if( a != b ) {");
        cog.outl("        log_bytes32('Not equal!');")
        cog.outl("        log_bytes32(err);")
        cog.outl("        log_named_" + type + "('A', a);")
        cog.outl("        log_named_" + type + "('B', b);")
        cog.outl("        fail();")
        cog.outl("    }")
        cog.outl("}")

        cog.out("function " + fname + "(")
        cog.outl(type + " a, " + type + " b) {")
        cog.outl("    if( a != b ) {");
        cog.outl("        log_bytes32('Not equal!');")
        cog.outl("        log_named_" + type + "('A', a);")
        cog.outl("        log_named_" + type + "('B', b);")
        cog.outl("        fail();")
        cog.outl("    }")
        cog.outl("}")


    ]]]*/
    //[[[end]]]




}
