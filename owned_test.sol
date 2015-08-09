import 'dappsys/test/test.sol';
import 'dappsys/owned.sol';

contract OwnedContract is DSOwned {
    bool public breached;
    function breach() ds_owner() {
        breached = true;
    }
}
contract OwnedTest is Test {
    OwnedContract o;
    function setUp() {
        o = new OwnedContract();
    }
    function testOwnerCanBreach() {
        o.breach();
        assertTrue(o.breached(), "owner couldn't call");
    }
    function testNonOwnerCantBreach() {
        o._ds_transfer_ownership( address(0x0) );
        o.breach();
        assertFalse(o.breached(), "non-owner breached");
    }
}
