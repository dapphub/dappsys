import 'dappsys/test/test.sol';
import 'dappsys/protected.sol';

contract DefaultProtectorInterfaceTest is Test {
    DSProtectorInterface p;
    function setUp() {
        p = new DSProtectorInterface();
    }
    function testFallbackReturnsFalse() {
        var ok = p.call(0x1);
        assertFalse( ok );
    }
    function testCanCallReturnsFalse() {
        var ok = p.can_call(msg.sender, address(this), msg.sig);
        assertFalse( ok );
    }

}
