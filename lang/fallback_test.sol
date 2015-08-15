import 'dappsys/test/test.sol';

contract IntReturnerInterface {
    function get() returns (int);
}
contract FallbackReturner {
    function() returns (int) {
        return 42;
    }
}
contract FallbackTest is Test {
    FallbackReturner f;
    function setUp() {
        f = new FallbackReturner();
    }
    function testFallbackReturn() {
        var ret = IntReturnerInterface(f).get();
        assertEq(ret, 42, "wrong return value");
    }
}
