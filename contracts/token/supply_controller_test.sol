import 'dapple/test.sol';

import 'auth/basic_authority.sol';
import 'data/balance_db.sol';
import 'token/supply_controller.sol';

contract DSTokenSupplyControllerTest is Test, DSAuthUser {
    DSBalanceDB db;
    DSBasicAuthority authority;
    DSTokenSupplyController controller;
    function DSTokenSupplyControllerTest() {
        authority = new DSBasicAuthority();
    }

    function setUp() {
        db = new DSBalanceDB();
        controller = new DSTokenSupplyController(db);
        db.updateAuthority(authority, DSAuthModes.Authority);
        authority.setCanCall(
          controller, db, bytes4(sha3('addBalance(address,uint256)')), true);
        authority.setCanCall(
          controller, db, bytes4(sha3('subBalance(address,uint256)')), true);

        controller.updateAuthority(authority, DSAuthModes.Authority);
        authority.setCanCall(
          this, controller, bytes4(sha3('demand(uint256)')), true);
        authority.setCanCall(
          this, controller, bytes4(sha3('destroy(uint256)')), true);
    }

    function testDemand() {
      assertEq(db.getBalance(this), 0);
      controller.demand(10);
      assertEq(db.getBalance(this), 10);
      assertEq(db.getSupply(), 10);
    }

    function testDestroy() {
      assertEq(db.getBalance(this), 0);
      assertEq(db.getBalance(controller), 0);
      assertEq(db.getSupply(), 0);

      controller.demand(10);
      assertEq(db.getBalance(this), 10);
      assertEq(db.getBalance(controller), 0);
      assertEq(db.getSupply(), 10);

      controller.destroy(9);
      assertEq(db.getBalance(this), 1);
      assertEq(db.getBalance(controller), 0);
      assertEq(db.getSupply(), 1);
    }
}
