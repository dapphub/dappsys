import 'proxy/base_proxy_test.sol';

contract CallReceiver {
    bytes public last_calldata;
    uint public last_value;
    function() {
        last_calldata = msg.data;
        last_value = msg.value;
    }
}

// "SimpleProxyTest"
contract DSBaseProxyTest is Test {
    bytes calldata;
    DSSimpleProxy p;
    CallReceiver cr;
    function setUp() {
        p = new DSSimpleProxy();
        cr = new CallReceiver();
    }
    function testProxyCall() {
        calldata.push(0x0);
        calldata.push(0x1);
        calldata.push(0x2);
        calldata.push(0x3);
        p.exec( address(cr), 0, calldata );
        assertTrue( cr.last_calldata() == calldata );
    }
}
