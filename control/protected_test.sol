import 'dappsys/test/test.sol';
import 'dappsys/control/protected.sol';

contract FallbackTester is DSProtected {
    bool public breached;
    function() auth() returns (uint) {
        breached = true;
    }
}

contract ProtectedTest is Test {
    DSProtected p;
    function setUp() {
        p = new DSProtected();
    }
    function testAuthProtectsFallback() {
        var f = new FallbackTester();
        f.call();
        assertFalse(f.breached(), "should be protected");
    }
}
