import "dappsys/test/test.sol";
import "dappsys/asset/issuable_asset.sol";

contract DSIssuableAssetTest is Test {
    DSIssuableAsset a;
    function setUp() {
        a = new DSIssuableAsset();
    }
    function testIssuanceUnlockedByDefault() {
        var ok = a.issue( address(0x1), 100 );
        assertTrue(ok, "issuance default locked");
    }
    function testIssuanceLock() {
        a.lock_issuance();
        var ok = a.issue( address(0x1),  100 );
        assertFalse( ok, "issue should fail if locked");
        assertEq( 0, a.balances(address(0x1)), "shouldn't issue when locked");
    }

}
