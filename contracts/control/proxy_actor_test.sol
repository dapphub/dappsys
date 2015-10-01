import 'dapple/core/test.sol';
import 'control/proxy_actor.sol';


contract Mock is Debug {
    uint public magic;
    function Mock() {
        magic = 0;
    }
    function poke() {
        logs("inside poke function");
        magic = 102;
    }
    function() {
        logs("inside mock fallback function");
    }
}

contract ProxyActorTest is Test {
    DSProxyActor a;
    Mock m;
    function setUp() {
        a = new DSProxyActor();
        a._ds_set_authority( DSAuthorityInterface(this), 0x0 );
        m = new Mock();
    }
    function test_void_action() {
        var ok = a._ds_set_call_target( address( m ) );
        assertTrue(ok, "couldn't set call target");
        log_named_uint("magic before", m.magic());
        Mock(a).poke();
        assertEq(102, m.magic(), "did not poke");
        log_named_uint("magic after", m.magic());
        
    }
}
