import 'dappsys/math/math.sol';

contract DSFixedPointMathUserTest is Test
                                   , DSFixedPointMathUser(10**18)
{
    uint half; uint one; uint two; uint three; uint four; uint six;
    function setUp() {
        one = unit(1); two = unit(2); three = unit(3);
        four = unit(4); six = unit(6);
        half = _precision / 2;
    }
    function testUnitConstructor() {
        assertEq(2 * (10**18), two, "wrong precision");
        assertEq(50000 * (10**18), unit(50000), "wrong precision");
    }
    function testMul() {
        assertEq(mul(two, three), six, "mul gave wrong answer");
        assertEq(mul(half, six), three, "mul gave wrong answer");
    }
    function testDiv() {
        assertEq(div(six, two), three, "div gave wrong answer");
        assertEq(div(two, half), four, "div gave wrong answer");
    }
    function testPow() {
        assertEq(pow(two, two), four, "pow gave wrong answer");
        assertEq(pow(three, two), unit(9), "pow gave wrong answer");
    }
}
