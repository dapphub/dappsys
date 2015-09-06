import 'dappsys/control/auth.sol';
import 'dapple/debug.sol';

// Linear-time median-finding
contract MedianFinder is DSAuth
{
    // slot 0 is a free-for all because of the default value
    // of setter_slots. Slot 0 is not included in the median.
    uint[] slots;
    uint num_slots;
    mapping( address => uint )  setter_slots;
    bool dirty;
    function swap(uint i, uint j) internal {
        uint v = slots[i];
        slots[i] = slots[j];
        slots[j] = v;
    }
    // Based on http://www.i-programmer.info/babbages-bag/505-quick-median.html
    function get_median() returns (uint median)
    {
        var L = 1;
        var R = num_slots;
        var k = (num_slots/2) + 1;
        while( L < R ) {
            var i = L;
            var j = R;
            // do-while body
            var x = slots[k];
            while(slots[i] < x) { i++; }
            while(slots[j] > x) { j--; }
            if( i <= j ) {
                swap(i, j);
                i++; j--;
            }
            // end
            while(i <= j) {
                // do-while body again
                x = slots[k];
                while(slots[i] < x) { i++; }
                while(slots[j] > x) { j--; }
                if( i <= j ) {
                    swap(i, j);
                    i++; j--;
                }
                // end
            }
            if( j < k ) {
                L = i;
            }
            if( k < i ) {
                R = j;
            }
        }
        return slots[k];
    }
    function set( uint value ) {
        slots[setter_slots[msg.sender]] = value;
    }
    function set_slot( address who, uint slot )
             auth()
             returns (bool)
    {
        setter_slots[who] = slot;
        return true;
    }
    function set_num_slots( uint num )
             auth()
             returns (bool)
    {
        if( num > num_slots ) {
            slots.length = num+1;
        }
        num_slots = num;
        return true;
    }
}
