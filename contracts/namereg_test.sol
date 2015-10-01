import 'dapple/core/test.sol';
import 'namereg.sol';


contract NameRegTest is Test {
    DSNameReg reg;
    function setUp() {
        reg = new DSNameReg();
    }
}
