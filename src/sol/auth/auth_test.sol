import 'dapple/test.sol';
import 'auth/authority.sol';
import 'auth/auth.sol';
import 'auth/reject.sol';

contract AcceptingAuthority {
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool)
    {
        return true;
    }
}

contract Vault is DSAuth { //, DSSigHelperMixin {
    bool public breached;
    uint public coins;
    function Vault() {
        reset();
    }
    function reset() {
        coins = 50;
        breached = false;
    }
    // 0x0b6142fc
    function breach() auth() {
        breached = true;
        coins = 4;
    }
    function look() auth() returns (uint) {
        return coins;
    }
}

contract AuthTest is Test {
    Vault v;
    //SigHelper s;
    AcceptingAuthority AA;
    RejectingAuthority RA;
    bytes4 breach_sig;
    bytes4 look_sig;
    function setUp() {
        v = new Vault();
     //   s = new SigHelper();
        RA = new RejectingAuthority();
        AA = new AcceptingAuthority();
    }
    function testOwnerCanBreach() {
        v.breach();
        assertTrue(v.breached(), "owner failed to call");
    }
    function testNonOwnerCantBreach() {
        v._ds_update_authority( DSAuthority(0x0), 0 );
        v.breach();
    }
    function testTransferToAcceptAuthority() {
        v._ds_update_authority( AA, 1 );
        v.breach();
        assertTrue( v.breached(), "authority failed to accept");
    }
    function testTransferToRejectAuthority() {
        v._ds_update_authority( RA, 1 );
        v.breach();
        this.assertFalse( v.breached(), "authority failed to reject");
    }
    // This test was used to confirm we need an explicit auth mode argument
    function testTransferToNullAuthority() {
        var ok = v._ds_update_authority( DSAuthority(address(bytes32(0x3))), 0 );
	assertTrue(ok, "couldn't update authority!");
        v.breach();
        this.assertFalse( v.breached(), "authority failed to reject");
    }
}
