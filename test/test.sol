contract Test {
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
    // These should be generated for each type

    event log_bytes32(bytes32 val);
    event log_bytes8(bytes8 val);
    event log_bytes4(bytes4 val);

    event log_named_bytes32(bytes32 key, bytes32 val);
    event log_named_bytes8(bytes32 key, bytes8 val);
    event log_named_bytes4(bytes32 key, bytes4 val);
    event log_named_uint(bytes32 key, uint val);
    event log_named_address(bytes32 key, address val);

    function fail() {
        failed = true;
    }
    function testAlwaysFail() returns (bool) {
        return false;
    }
    function assertTrue(bool what, bytes32 error) {
        if( !what) {
            log_named_bytes32("failed assertTrue:  ", error);
            fail();
        }
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
    function assertEq(bytes8 a, bytes8 b, bytes32 err) {
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
