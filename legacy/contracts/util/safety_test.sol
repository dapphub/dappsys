import 'dapple/test.sol';
import 'util/safety.sol';

contract SafeAddSubTest is Test, DSSafeAddSub {
    function setUp() {
    }
    function testSafeToAddFix() {
        assertTrue(safeToAdd(1, 0));
    }
}
