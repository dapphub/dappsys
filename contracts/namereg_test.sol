import 'dapple/test/test.sol';
import 'dappsys/namereg.sol';


contract NameRegTest is Test {
    DSNameReg reg;
    function setUp() {
        reg = new DSNameReg();
    }
}
