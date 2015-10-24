// Confirm the behavior of EVM stack overflow.

import 'core/test.sol';

contract OverflowTest is Test {
    function helper(uint depth) external returns (bytes32 val, bool ok) {
        bytes32 magic = 0x42;
        if( depth == 109 ) {
            return (magic, true);
        }
        var (ret, is_ok) = this.helper(depth+1);
        //log_uint(depth);
        //log_bytes32(ret);
        return (magic, true);
    }
    function testOverflow() {
        this.helper( 1 );
    }
}
