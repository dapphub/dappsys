import 'dapple/test.sol';
import 'util/fallback_failer.sol';

contract FallbackUser {
    function exec();
}

contract FallbackFailerTest {
    DSFallbackFailer fb;

    function DSTrueFallbackTest() {
        fb = new DSFallbackFailer();
    }

    function testFailFallback() {
        FallbackUser(fb).exec();
    }
}
