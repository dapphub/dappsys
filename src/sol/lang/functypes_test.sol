import 'dapple/test.sol';

contract WithIdentifier {
    bool public transferred;
    function transfer( address to, uint amount, bytes32 id ) returns (bool ok) {
        transferred = true;
        return true;
    }
}

contract NoIdentifier {
    bool public transferred;
    function transfer( address to, uint amount ) returns (bool ok) {
        transferred = true;
        return true;
    }
}


contract SignatureBehaviorTest is Test {
    WithIdentifier wid;
    NoIdentifier   nid;
    function setUp() {
        wid = new WithIdentifier();
        nid = new NoIdentifier();
    }
    function testExcludingID() {
        var ok = NoIdentifier(wid).transfer( address(this), 100 );
        assertTrue( ok );
        assertTrue( wid.transferred() );
    }
}
