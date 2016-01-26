import 'actor/base_actor.sol';
import 'dapple/test.sol';
import 'dapple/debug.sol';

// Simple example and passthrough for testing
contract DSSimpleActor is DSBaseActor {
    function execute( address target, bytes calldata, uint value, uint gas )
             returns (bool call_ret )
    {
        return exec( target, calldata, value, gas );
    }
}


// Test helper: record calldata from fallback and compare.
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
        for( var i = 0; i < 35; i++ ) {
            calldata.push(byte(i));
        }
        a.execute( address(cr), calldata, 0, 0 );
        var length = cr.compareLastCalldata( calldata );
        assertTrue( cr.compareLastCalldata( calldata ) );
    }
}
