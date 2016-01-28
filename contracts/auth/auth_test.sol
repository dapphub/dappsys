import 'dapple/test.sol';
import 'auth/authority.sol';
import 'auth/auth.sol';

contract Vault is DSAuth {
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
}

contract AuthTest is Test {
    Vault v;
    AcceptingAuthority AA;
    RejectingAuthority RA;
    bytes4 breach_sig;
    function setUp() {
        v = new Vault();
        RA = new RejectingAuthority();
        AA = new AcceptingAuthority();
    }
    function testOwnerCanBreach() {
        v.breach();
        assertTrue(v.breached(), "owner failed to call");
    }
    function testTransferToAcceptAuthority() {
        //v.updateAuthority( AA, true );
        //v.breach();
        //assertTrue( v.breached(), "authority failed to accept");
    }

    function testErrorNonOwnerCantBreach() {
        v.updateAuthority( DSAuthority(0x0), false );
        v.breach();
    }
    function testErrorTransferToRejectAuthority() {
        v.updateAuthority( RA, true );
        v.breach();
    }
    // This test was used to confirm we need an explicit auth mode argument
    function testErrorTransferToNullAuthority() {
        var ok = v.updateAuthority( DSAuthority(address(bytes32(0x3))), false );
        assertTrue(ok, "couldn't update authority!");
        v.breach();
    }
}
