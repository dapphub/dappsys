import 'dapple/core/test.sol';

contract updater is DSUpdateChain {
    uint val;
    function updater( uint value ) {
        val = value;
    }
    function get() returns (uint) {
        return val;
    }

    // "codegen"
    function latest_version() returns (updater) {
        return updater(_ds_get_latest_version());
    }
    function set_latest_version( address version ) {
        _ds_set_latest_version( version );
    }
}

contract user {
    updater u;
    function user( updater _u ) {
        u = _u;
    }
    function sync() {
        u = u.latest_version();
    }
    modifier syncs() {
        sync();
        _
    }
    function get()
             syncs()
             returns (uint)
    {
        return u.get();
    }
}

contract DSUpdateChainTest is Test {
    updater u1;
    updater u2;
    updater u3;
    function setUp() {
        u1 = new updater(1);
        u2 = new updater(2);
        u3 = new updater(3);
    }
    function testBasicUpdate() {
        var user1 = new user( u1 ); // follows continuously
        var user2 = new user( u1 ); // misses an update

        assertEq(user1.get(), 1);
        assertEq(user2.get(), 1);
        u1.set_latest_version( address(u2) );
        assertEq(user1.get(), 2);
        u2.set_latest_version( address(u3) );
        assertEq(user1.get(), 3);
        assertEq(user2.get(), 3);
    }
}
