import 'gov/multisig.sol';
import 'dapple/test.sol';

contract DSMultisig_Test is Test, DSMultisigActorUser
{
    Tester t1;
    Tester t2;
    Tester t3;
    DSMultisigActor ms;
    bytes calldata;
    function setUp() {
        t1 = new Tester(); t1._target( ms );
        t2 = new Tester(); t2._target( ms );
        ms = new DSMultisigActor();
        var update_action = proposeUpdateMember( ms, address(t1), true );
        ms.confirm( update_action );
        // `address(this)` is kept as a multisig member to simplify testing.
    }
    function testSetupWorked() {
        assertTrue( ms.is_member( address(this) ) );
        assertTrue( ms.is_member( t1 ) );
    }
}
