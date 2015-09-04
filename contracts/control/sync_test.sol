import 'dapple/test.sol';
import 'dappsys/control/sync.sol';
import 'dappsys/control/migrate.sol';


contract IDProvider {
    function id() returns (uint);
}

contract migratable is DSMigratable {
    migratable next;
    uint _id;
    function id() returns(uint) {
        return _id;
    }
    function migratable( uint id ) {
        _id = id;
    }
    function _ds_get_update() returns (address) {
        return address(next);
    }
    function update( migratable m ) {
        next = m;
    }
}

contract consumer is DSSync {
    migratable m;
    function consumer( migratable m )
    {
        sync_with( DSMigratable(m) );
    }
    modifier syncs() {
        _ds_sync();
        m = migratable(_m[0]);
        _
    }
    function get_provider() internal returns (IDProvider p) {
        return IDProvider(m);
    }
    function dostuff()
             syncs()
             returns (uint saw_id )
    {
        return get_provider().id();
    }
}

contract DSSyncTest is Test
{
    migratable t1;
    migratable t2;
    migratable t3;
    consumer c;
    function setUp() {
        t1 = new migratable(1);
        t2 = new migratable(2);
        t3 = new migratable(3);
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
