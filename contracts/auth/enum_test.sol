import 'dapple/test.sol';
import 'auth/enum.sol';

contract AuthEnumValuesTest is Test, DSAuthModesEnum {
    function setUp() {}
    // TODO how to test they are still the same ABI type?
    function testValues() {
        assertEq( 0, uint(DSAuthModes.Owner) );
        assertEq( 1, uint(DSAuthModes.Authority) );
    }
}
