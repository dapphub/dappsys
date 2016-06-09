// Some tests to verify behavior of fallbacks and rsult of calling addresses with unexpected types
// TODO demonstrate that garbage is not always calldata (except when calling no-code addresses)
import 'dapple/test.sol';

contract ThrowingFallback {
    function() {
        throw;
    }
}

contract UndefinedFunction {
    function undefinedFunction() returns (bytes32);
    function undefinedFunction2() returns (bytes32);
}

contract TypedFallback {
    function() returns (bytes32) {
        return 0x42;
        // same as "return bytes32(0x42);"
    }
}

contract UntypedFallback {
    function() {
        // same as "return bytes32(0x0);"
    }
}


contract UndefinedFallback {
    function iHaveCode() returns (bytes32) {
        return "aaaaa";
    }
}


contract FallbackTest is Test {
    ThrowingFallback throwing;
    TypedFallback typed;
    UntypedFallback untyped;
    UndefinedFallback undefined;
    address noCode;
    function setUp() {
        throwing = new ThrowingFallback();
        typed = new TypedFallback();
        untyped = new UntypedFallback();
        undefined = new UndefinedFallback();
        noCode = address(0x42);
    }
    function testFailThrowingFallback() {
        UndefinedFunction(throwing).undefinedFunction();
    }
    function testTypedFallbackReturnsFalse() {
        var ret = UndefinedFunction(typed).undefinedFunction();
        assertEq32(ret, 0x42);
    }
    function testUntypedFallbackReturnsGarbage() {
        var ret = UndefinedFunction(untyped).undefinedFunction();
        assertTrue( ret != bytes32(0), "ret is 0 by coincidence" );
    }
    function testUndefinedFallbackReturnsGarbage() {
        var ret = UndefinedFunction(undefined).undefinedFunction();
        assertTrue( ret != bytes32(0), "ret is 0 by coincidence" );
        log_named_bytes32("garbage", ret);
    }
    function testNoCodeReturnsGarbage() {
        var ret = UndefinedFunction(noCode).undefinedFunction();
        assertTrue( ret != bytes32(0), "ret is 0 by coincidence" );
        log_named_bytes32("garbage", ret);
    }
    function testInternalThrowReturns0() {
        var ret = throwing.call();
        assertFalse(ret);
    }
    function testInternalCallSuccessReturns1() {
        var ret = untyped.call();
        assertTrue(ret);
    }
}
