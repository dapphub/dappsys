import 'dapple/test.sol';
import 'util/false.sol';

contract FallbackUser {
    function exec() returns (bool);
}

contract DSFalseFallbackTest is Test {
    DSFalseFallback fb;

    function DSFalseFallbackTest() {
        fb = new DSFalseFallback();
    }

    function testFallback() {
        assertFalse(FallbackUser(fb).exec());
    }
}

