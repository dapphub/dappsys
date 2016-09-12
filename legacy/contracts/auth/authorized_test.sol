import 'dapple/test.sol';
import 'auth.sol';

contract DSAuthorizedUser is DSAuthorized {
    function triggerAuth() auth() returns (bool) {
        return true;
    }

    function triggerTryAuth() try_auth() returns (bool) {
        return true;
    }
}

contract DSAuthorizedTester is Tester {
    function doTriggerAuth() returns (bool) {
        return DSAuthorizedUser(_t).triggerAuth();
    }

    function doTriggerTryAuth() returns (bool) {
        return DSAuthorizedUser(_t).triggerTryAuth();
    }
}

contract DSAuthorizedTest is Test, DSAuthUser, DSAuthorizedEvents {
    DSAuthorizedUser auth;
    DSAuthorizedTester tester;

    function setUp() {
        auth = new DSAuthorizedUser();
        tester = new DSAuthorizedTester();
        tester._target(auth);
    }

    // Testing separately because setUp is a logging
    // blind spot at the moment.
    function testConstructorEvent() {
        var newAuth = new DSAuthorized();
        expectEventsExact(newAuth);
        DSAuthUpdate(this, DSAuthModes.Owner );
    }

    function testOwnedAuth() {
        assertTrue(auth.triggerAuth());
    }

    function testFailOwnedAuth() {
        tester.doTriggerAuth();
    }

    function testOwnedTryAuth() {
        assertTrue(auth.triggerTryAuth());
    }

    function testOwnedTryAuthUnauthorized() {
        assertFalse(tester.doTriggerTryAuth());
    }

    function testUpdateAuthorityEvent() {
        var accepter = new AcceptingAuthority();

        expectEventsExact(auth);
        DSAuthUpdate(accepter, DSAuthModes.Authority);

        auth.updateAuthority(accepter, DSAuthModes.Authority);
    }

    function testAuthorityAuth() {
        var accepter = new AcceptingAuthority();
        auth.updateAuthority(accepter, DSAuthModes.Authority);

        assertTrue(auth.triggerAuth());
    }

    function testFailAuthorityAuth() {
        var rejecter = new RejectingAuthority();
        auth.updateAuthority(rejecter, DSAuthModes.Authority);

        tester.doTriggerAuth();
    }

    function testAuthorityTryAuth() {
        var accepter = new AcceptingAuthority();
        auth.updateAuthority(accepter, DSAuthModes.Authority);

        assertTrue(auth.triggerTryAuth());
    }

    function testAuthorityTryAuthUnauthorized() {
        var rejecter = new RejectingAuthority();
        auth.updateAuthority(rejecter, DSAuthModes.Authority);

        assertFalse(tester.doTriggerTryAuth());
    }
}
