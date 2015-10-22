import 'data/median.sol';
import 'core/test.sol';


contract submitter {
    MedianFinder _mf;
    function submitter( MedianFinder mf ) {
        _mf = mf;
    }
    function submit(uint val) {
        _mf.set( val );
    }
}


contract MedianFinderTest is Test {
    MedianFinder mf;
    submitter[10] s;
    function setUp() {
        mf = new MedianFinder();
        mf.set_num_slots(10);
        for( var i = 0; i < 10; i++ ) {
            s[i] = new submitter(mf);
            mf.set_slot(address(s[i]), i);
        }
    }
    function testSimpleMedian() {
        mf.set_num_slots(3);
        s[1].submit(1);
        s[2].submit(2);
        s[3].submit(3);
        assertEq(2, mf.get_median());
    }
    function testOutOfOrderMedian() {
        mf.set_num_slots(5);
        s[1].submit(5);
        s[2].submit(2);
        s[3].submit(3);
        s[4].submit(4);
        s[5].submit(1);
        assertEq(3, mf.get_median());
    }
    function testMoreFeedsThanSlots() {
        mf.set_num_slots(3);
        s[1].submit(5);
        s[2].submit(2);
        s[3].submit(3);
        s[4].submit(4);
        s[5].submit(1);
        assertEq(3, mf.get_median()); // still ==3 because out of order
    }
}
