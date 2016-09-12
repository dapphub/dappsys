import 'dapple/test.sol';
import 'token/registry.sol';
import 'token/base.sol';

contract TokenRegistryTest is Test {
    uint constant issuedAmount = 1000;

    DSTokenBase token;
    DSTokenRegistry registry;

    function setUp() {
        registry = new DSTokenRegistry();
        token = new DSTokenBase(issuedAmount);
    }

    function testGetToken() {
        bytes32 tokenName = "Kanye Coin";
        registry.set(tokenName, bytes32(address(token)));
        assertEq(registry.getToken(tokenName), token);
    }
    function testFailGetUnsetToken() {
        bytes32 tokenName = "Kanye Coin";
        assertEq(registry.getToken(tokenName), token);
    }
    function testTryGetToken() {
        bytes32 tokenName = "Kanye Coin";
        registry.set(tokenName, bytes32(address(token)));
        var (_token, ok) = registry.tryGetToken(tokenName);
        assertTrue(ok);
        assertEq(token, _token);
        (_token, ok) = registry.tryGetToken("NIL");
        assertFalse(ok);
    }
}
