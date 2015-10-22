import 'core/test.sol';
import 'lang/sig_helper.sol';
import 'auth/auth.sol';

contract AcceptingAuthority {
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool)
    {
        return true;
    }
}

contract RejectingAuthority {
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool)
    {
        return false;
    }
}

contract Vault is DSAuth, DSSigHelperMixin {
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
    function breach() printsig() auth() {
        breached = true;
        coins = 4;
    }
    function look() auth() returns (uint) {
        return coins;
    }
}

contract AuthTest is Test {
    Vault v;
    SigHelper s;
    AcceptingAuthority AA;
    RejectingAuthority RA;
    bytes4 breach_sig;
    bytes4 look_sig;
    function setUp() {
        v = new Vault();
        s = new SigHelper();
        RA = new RejectingAuthority();
        AA = new AcceptingAuthority();
    }
    function testOwnerCanBreach() {
        v.breach();
        assertTrue(v.breached(), "owner failed to call");
    }
    function testNonOwnerCantBreach() {
        v._ds_set_authority( DSAuthority(0x0), 0x0 );
        v.breach();
    }
    function testTransferToAcceptAuthority() {
        v._ds_set_authority( AA, 0x1 );
        v.breach();
        assertTrue( v.breached(), "authority failed to accept");
    }
    function testTransferToRejectAuthority() {
        v._ds_set_authority( RA, 0x1 );
        v.breach();
        assertFalse( v.breached(), "authority failed to reject");
    }
}
