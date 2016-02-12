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
        assertTrue(this.balance > 0, "insufficient funds");

        a = new DSSimpleActor();
        a.send(10 wei);
        cr = new CallReceiver();
    }
    function testProxyCall() {
        for( var i = 0; i < 35; i++ ) {
            calldata.push(byte(i));
        }
        assertTrue(a.execute( address(cr), calldata, 0, 0 ));
        assertTrue( cr.compareLastCalldata( calldata ) );
    }
    function testProxyCallWithInsufficientGas() {
        for( var i = 0; i < 35; i++ ) {
            calldata.push(byte(i));
        }
        assertFalse(a.execute( address(cr), calldata, 0, 1 ));
        assertFalse( cr.compareLastCalldata( calldata ) );
    }
    function testProxyCallWithSufficientGas() {
        for( var i = 0; i < 35; i++ ) {
            calldata.push(byte(i));
        }
        assertTrue(a.execute( address(cr), calldata, 0, msg.gas - 1000000 ));
        assertTrue( cr.compareLastCalldata( calldata ) );
    }
    function testProxyCallWithValue() {
        assertEq(cr.balance, 0, "callreceiver already has ether");

        for( var i = 0; i < 35; i++ ) {
            calldata.push(byte(i));
        }
        assertEq(a.balance, 10 wei, "ether not sent to actor");
        assertTrue(a.execute(address(cr), calldata, 10 wei, 0),
                   "execute failed");
        assertTrue( cr.compareLastCalldata( calldata ),
                   "call data does not match" );
        assertEq(cr.balance, 10 wei);
    }
}
