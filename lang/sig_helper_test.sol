import 'dapple/test/test.sol';
import 'dappsys/lang/sig_helper.sol';

contract SigHelperTest is Test
                        , DSSigHelperMixin
{
    SigHelper s;
    function setUp() {
        s = new SigHelper();
    }
    function testCheckSigs() {
        s.assets("TEST");
        assertEq4(0x73b4fbd7, s.last_sig(), "wrong sig!!");
        s.poke();
        //log_named_bytes4("True poke sig:", s.last_sig());
    }
    function testGetSig() {
        var actual = s.get_my_sig();
        var static = s.last_sig();
        assertEq4(actual, static, "get_my_sig doesn't work");
        //log_bytes4( s.get_my_sig() );
        //log_bytes4( s.last_sig() );
    }
    function testFallbackStaticSig() {
        s.call(0x1);
        assertEq4( 0x0, s.last_sig(), "fallback sig != 0x0" );
    }
}
