import 'math/math.sol';

contract DSFixedPointMathUserTest is Test
                                   , DSFixedPointMathMixin(10**18)
{
    uint half; uint one; uint two; uint three; uint four; uint six;
    function setUp() {
        one = _fxp_unit(1); two = _fxp_unit(2); three = _fxp_unit(3);
        four = _fxp_unit(4); six = _fxp_unit(6);
        half = _precision / 2;
    }
    function testUnitConstructor() {
        assertEq(2 * (10**18), two, "wrong precision");
        assertEq(50000 * (10**18), _fxp_unit(50000), "wrong precision");
    }
    function testMul() {
        assertEq(_fxp_mul(two, three), six, "_fxp_mul gave wrong answer");
        assertEq(_fxp_mul(half, six), three, "_fxp_mul gave wrong answer");
    }
    function testDiv() {
        assertEq(_fxp_div(six, two), three, "_fxp_div gave wrong answer");
        assertEq(_fxp_div(two, half), four, "_fxp_div gave wrong answer");
    }
    function testPow() {
        assertEq(_fxp_pow(two, two), four, "_fxp_pow gave wrong answer");
        assertEq(_fxp_pow(three, two), _fxp_unit(9), "_fxp_pow gave wrong answer");
    }
}
