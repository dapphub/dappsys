import 'actor/base_actor.sol';
import 'dapple/test.sol';
import 'dapple/debug.sol';

contract CallReceiver is Debug {
    bytes last_calldata;
    uint last_value;
    function compareLastCalldata( bytes data ) returns (bool) {
        // last_calldata.length might be longer because calldata is padded
        // to be a multiple of the word size
        if( data.length > last_calldata.length ) {
            return false;
        }
        for( var i = 0; i < data.length; i++ ) {
            if( data[i] != last_calldata[i] ) {
                return false;
            }
        }
        return true;
    }
    function() {
        last_calldata = msg.data;
        last_value = msg.value;
    }
}

// actually tests "SimpleActorTest"
contract DSBaseActorTest is Test {
    bytes calldata;
    DSSimpleActor a;
    CallReceiver cr;
    function setUp() {
        a = new DSSimpleActor();
        cr = new CallReceiver();
    }
    function testProxyCall() {
        calldata.push(byte(0x0));
        calldata.push(byte(0x1));
        calldata.push(byte(0x2));
        calldata.push(byte(0x3));
        calldata.push(byte(0x4));

        a.execute( address(cr), calldata, 0, 0 );
        var length = cr.compareLastCalldata( calldata );
        assertTrue( cr.compareLastCalldata( calldata ) );
    }
}
