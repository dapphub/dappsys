import 'dappsys/test/test.sol';
import 'dappsys/protected.sol';

contract MockAuthority is DSAuthorityInterface {
    function can_call( address caller, address callee, bytes4 sig )
             returns (bool)
    {
        return true;
    }
}
contract ProtectedTest is Test {
    MockAuthority a;
    DSProtected p;
    function setUp() {
        a = new MockAuthority();
        p = new DSProtected();
        p._ds_init_authority( a );
    }
}

contract AuInterfaceTest is Test {
    DSAuthorityInterface p;
    function setUp() {
        p = new DSAuthorityInterface();
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
