import 'dapple/contracts/test.sol';
import 'dappsys/control/transient.sol';


contract IDProvider {
    function id() returns (uint);
}

contract transient is DSTransient {
    DSTransient next_t;
    uint _id;
    function id() returns(uint) {
        return _id;
    }
    function transient( uint id ) {
        _id = id;
    }
    function _ds_get_update() returns (address) {
        if( next_t == DSTransient(0x0) ) {
            return address(this);
        } else {
            return address(next_t);
        }
    }
    function update( DSTransient t ) {
        next_t = t;
    }
}

contract consumer is DSTransientContractConsumer {
    function consumer( DSTransient t)
             DSTransientContractConsumer( t )
    {
    }
    function get_provider() internal returns (IDProvider p) {
        return IDProvider(t);
    }
    function dostuff()
             syncs()
             returns (uint saw_id )
    {
        return get_provider().id();
    }
}

contract DSTransientTest is Test
{
    transient t1;
    transient t2;
    transient t3;
    consumer c;
    function setUp() {
        t1 = new transient(1);
        t2 = new transient(2);
        t3 = new transient(3);
        c = new consumer(t1);
    }
    function testSyncBeforeUpdate() {
        var id = c.dostuff();
        assertEq(id, 1);
    }
    function testSyncAfterUpdate() {
        var id = c.dostuff();
        assertEq(id, 1);
        t1.update( t2 );
        id = c.dostuff();
        assertEq(id, 2);
    }
    function testUpdateChainTraversal() {
        t1.update( t2 );
        t2.update( t3 );
        var id = c.dostuff();
        assertEq(id, 3);
    }
}
