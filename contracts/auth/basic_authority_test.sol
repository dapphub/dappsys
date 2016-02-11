import 'dapple/test.sol';
import 'auth/authority.sol';
import 'auth/auth_test.sol';  // Vault
import 'auth/basic_authority.sol';


contract BasicAuthorityTest is Test, DSAuthorityEvents {
    DSBasicAuthority a;
    DSBasicAuthority a2;
    Vault v;
    function setUp() {
        a = new DSBasicAuthority();
        v = new Vault();
        v.updateAuthority(a, true);
    }
    function testExportAuthorized() {
        expectEventsExact(a);
        DSSetCanCall(this, v, bytes4(sha3("updateAuthority(address,bool)")),
                     true);

        a.setCanCall(this, v, bytes4(sha3("updateAuthority(address,bool)")),
                     true);

        v.updateAuthority( address(this), false );
        v.breach();
        assertTrue( v.breached(), "couldn't after export attempt" );
    }
    function testFailBreach() {
        v.breach(); // throws
    }
    function testNormalWhitelistAdd() {
        expectEventsExact(a);
        DSSetCanCall(this, v, bytes4(sha3("breach()")), true);

        a.setCanCall( me, address(v), bytes4(sha3("breach()")), true );
        v.breach();
        assertTrue( v.breached() );
        v.reset();
    }
    function testFailNormalWhitelistReset() {
        expectEventsExact(a);
        DSSetCanCall(this, v, bytes4(sha3("breach()")), false);

        a.setCanCall( me, address(v), bytes4(sha3("breach()")), true );
        v.breach();
        assertTrue( v.breached() );
        a.setCanCall( me, address(v), bytes4(sha3("breach()")), false );
        v.breach();
    }
}
