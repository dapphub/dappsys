// Confirm the behavior of EVM stack overflow.

import 'core/test.sol';

contract OverflowTest is Test {
    function helper(uint depth) external returns (bytes32 val, bool ok) {
        logs("in helper");
        bytes32 magic = 0x42;
        if( depth == 109 ) {
            return (magic, true);
        }
        var (ret, is_ok) = this.helper(depth+1);
/*
        if( depth == 5 ) {
            assertFalse( is_ok );
            assertEq32( ret, 0x0 );
        } else {
            assertTrue( is_ok );
            assertEq32( ret, magic );
        }
*/
        return (magic, true);
    }
    function testOverflow() {
        this.helper( 1 );
    }
}
