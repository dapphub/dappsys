import 'dapple/test.sol';

contract WithIdentifier {
    bool public transferred;
    bool public missed;
    function transfer( address to, uint amount, bytes32 id ) returns (bool ok) {
        transferred = true;
        return true;
    }
    function() {
        missed = true;
    }
}

contract NoIdentifier {
    function transfer( address to, uint amount ) returns (bool ok);
}


contract SignatureBehaviorTest is Test {
    WithIdentifier wid;
    function setUp() {
        wid = new WithIdentifier();
    }
    function testHypothesis() {
        NoIdentifier(wid).transfer( address(this), 100 );
        assertFalse( wid.transferred() ); // assertTrue( wid.transferred() );   wrong hypothesis
    }
    function testReality() {
        NoIdentifier(wid).transfer(address(this), 100);
        assertTrue( wid.missed() );
        assertFalse( wid.transferred() );
        wid.transfer( address(this), 100, "identifier" );
        assertTrue( wid.transferred() );
    }
}
