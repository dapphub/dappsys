import "dappsys/test/test.sol";
import "dappsys/asset/asset.sol";

contract MockDepositAcceptor is DSAssetAcceptorInterface {
}

contract DSBaseAssetTest is Test {
    DSBaseAsset a;
    function setUp() {
        a = new DSBaseAsset();
    }
}
