import 'dappsys/test/test.sol';
import 'dappsys/control/dynabi.sol';

contract DynABI_Test is Test {
    DSDynABI d;
    function setUp() {
        d = new DSDynABI();
    }
}
