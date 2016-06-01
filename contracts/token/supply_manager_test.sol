import 'dapple/test.sol';

import 'auth.sol';
import 'auth/basic_authority.sol';
import 'data/balance_db.sol';
import 'token/supply_manager.sol';

// Used by maker-core
contract TestTokenSupplyManager is DSTokenSupplyManager
{
    function TestTokenSupplyManager( DSBalanceDB db )
             DSTokenSupplyManager( db )
    {
    }

    // Allow anyone to demand however much they want.
    function demand(uint amount)
    {
        _db.addBalance(msg.sender, amount);
    }
}

contract DSTokenSupplyManagerTest is Test, DSAuthUser {
    DSBalanceDB db;
    DSBasicAuthority authority;
    DSTokenSupplyManager manager;
    function DSTokenSupplyManagerTest() {
        authority = new DSBasicAuthority();
    }

    function setUp() {
        db = new DSBalanceDB();
        manager = new DSTokenSupplyManager(db);
        db.updateAuthority(authority, DSAuthModes.Authority);
        authority.setCanCall(
          manager, db, bytes4(sha3('addBalance(address,uint256)')), true);
        authority.setCanCall(
          manager, db, bytes4(sha3('subBalance(address,uint256)')), true);

        manager.updateAuthority(authority, DSAuthModes.Authority);
        authority.setCanCall(
          this, manager, bytes4(sha3('demand(uint256)')), true);
        authority.setCanCall(
          this, manager, bytes4(sha3('destroy(uint256)')), true);
    }

    function testDemand() {
      assertEq(db.getBalance(this), 0);
      manager.demand(10);
      assertEq(db.getBalance(this), 10);
      assertEq(db.getSupply(), 10);
    }

    function testDestroy() {
      assertEq(db.getBalance(this), 0);
      assertEq(db.getBalance(manager), 0);
      assertEq(db.getSupply(), 0);

      manager.demand(10);
      assertEq(db.getBalance(this), 10);
      assertEq(db.getBalance(manager), 0);
      assertEq(db.getSupply(), 10);

      manager.destroy(9);
      assertEq(db.getBalance(this), 1);
      assertEq(db.getBalance(manager), 0);
      assertEq(db.getSupply(), 1);
    }
}
