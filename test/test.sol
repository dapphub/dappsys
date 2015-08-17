import 'dappsys/test/debug.sol';

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
            fail();
        }
    }
    function assertTrue(bool what, bytes32 error) {
        if( !what ) {
            log_bytes32(error);
            fail();
        }
    }
    function assertFalse(bool what) {
        assertTrue(!what);
    }
    function assertFalse(bool what, bytes32 error) {
        assertTrue(!what, error);
    }
    function assertEq(uint a, uint b, bytes32 err) {
        if( a != b ) {
            log_bytes32("Not equal!");
            log_named_uint("A", a);
            log_named_uint("B", b);
            fail();
        }
    }
    function assertEq(int a, int b, bytes32 err) {
        if( a != b ) {
            log_bytes32("Not equal!");
            log_named_int("A", a);
            log_named_int("B", b);
            fail();
        }
    }
    function assertEq(bytes32 a, bytes32 b, bytes32 err) {
        if( a != b ) {
            log_bytes32("Not equal!");
            log_named_bytes32("A", a);
            log_named_bytes32("B", b);
            fail();
        }
    }

    function assertEq8(bytes8 a, bytes8 b, bytes32 err) {
        if( a != b ) {
            log_bytes32("Not equal!");
            log_named_bytes8("A", a);
            log_named_bytes8("B", b);
            fail();
        }
    }
    function assertEq4(bytes4 a, bytes4 b, bytes32 err) {
        if( a != b ) {
            log_bytes32("Not equal!");
            log_named_bytes4("A", a);
            log_named_bytes4("B", b);
            fail();
        }
    }




}
