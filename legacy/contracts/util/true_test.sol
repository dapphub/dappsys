import 'dapple/test.sol';
import 'util/true.sol';

contract FallbackUser {
    function exec() returns (bool);
}

contract DSTrueFallbackTest is Test {
    DSTrueFallback fb;

    function DSTrueFallbackTest() {
        fb = new DSTrueFallback();
    }

    function testFallback() {
        assertTrue(FallbackUser(fb).exec());
    }
}
