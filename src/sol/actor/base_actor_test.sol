import 'actor/base_actor.sol';
import 'dapple/test.sol';
import 'dapple/debug.sol';

contract CallReceiver is Debug {
    bytes public last_calldata;
    uint public last_value;
    // You can't pass `bytes` around yet...
    function lastCalldataPrefix() returns (byte[4]) {
        byte[4] memory b;
        for( var i = 0; i < 4 && i < last_calldata.length; i++ ) {
            b[i] = last_calldata[i];
        }
        return b;
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
        byte[4] memory prefix;
        calldata.push(0x0);
        calldata.push(0x1);
        calldata.push(0x2);
        calldata.push(0x3);
        prefix[0] = 0x0;
        prefix[1] = 0x1;
        prefix[2] = 0x2;
        prefix[3] = 0x3;

        a.execute( address(cr), calldata, 0, 0 );
        var last = cr.lastCalldataPrefix();
        for( var i = 0; i < 4; i++ ) {
            assertTrue( last[i] == prefix[i] );
        }
    }
}
