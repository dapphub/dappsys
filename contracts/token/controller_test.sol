import 'auth.sol';
import 'dapple/test.sol';
import 'token/controller.sol';
import 'data/approval_db.sol';
import 'data/balance_db.sol';
import 'token/erc20.sol';
import 'token/event_callback.sol';
import 'token/frontend.sol';
import 'token/token.sol';

import 'util/safety.sol';

contract TokenControllerTest is ERC20Events, DSAuthUser, Test {
    uint constant issuedAmount = 1000;

    DSBalanceDB balanceDB;
    DSApprovalDB approvalDB;
    DSTokenController controller;
    DSTokenFrontend frontend;

    Tester user1;
    Tester user2;

    function TokenControllerTest() {
        approvalDB = new DSApprovalDB();
        balanceDB = new DSBalanceDB();
        controller = new DSTokenController(balanceDB, approvalDB);
        frontend = new DSTokenFrontend(controller);
    }

    function setUp() {
        user1 = new Tester();
        user2 = new Tester();

        balanceDB.setBalance(controller, issuedAmount);
        balanceDB.updateAuthority(controller, DSAuthMode.Owner);
        approvalDB.updateAuthority(controller, DSAuthMode.Owner);
        frontend.updateAuthority(controller, DSAuthMode.Owner);
        controller.setFrontend(frontend);
    }

    function testGetFrontend() {
        assertEq(address(controller.getFrontend()), address(frontend));
    }

    function testSetFrontend() {
        var newFrontend = new DSTokenFrontend(controller);
        controller.setFrontend(newFrontend);
        assertEq(address(controller.getFrontend()), address(newFrontend));
    }

    function testGetApprovalDb() {
        var _approvalDB = controller.getApprovalDB();
        assertEq(address(_approvalDB), address(_approvalDB));
    }

    function testSetApprovalDb() {
        var newApprovalDB = new DSApprovalDB();
        controller.setApprovalDB(newApprovalDB, 0xf00b42, DSAuthModes.Owner);
        assertEq(approvalDB._authority(), 0xf00b42, "authority not set");
        assertEq(controller.getApprovalDB(), newApprovalDB, "db not set");
    }

    function testGetBalanceDb() {
        var _balanceDB = controller.getBalanceDB();
        assertEq(address(_balanceDB), address(_balanceDB));
    }

    function testSetBalanceDb() {
        var newBalanceDB = new DSBalanceDB();
        controller.setBalanceDB(newBalanceDB, 0xf00b42, DSAuthModes.Owner);
        assertEq(balanceDB._authority(), 0xf00b42, "authority not set");
        assertEq(controller.getBalanceDB(), newBalanceDB, "db not set");
    }

    function testAllowanceStartsAtZero() logs_gas {
        assertEq(controller.allowance(user1, user2), 0);
    }

    function testBalanceOfStartsAtZero() logs_gas {
        assertEq(controller.balanceOf(user1), 0);
    }

    function testBalanceOfReflectsTransfer() logs_gas {
        uint sentAmount = 250;
        controller.transfer(controller, user1, sentAmount);
        assertEq(controller.balanceOf(user1), sentAmount);
    }

    function testTotalSupply() logs_gas {
        assertEq(controller.totalSupply(), issuedAmount);
    }

    function testValidTransfers() logs_gas {
        uint sentAmount = 250;
        controller.transfer(controller, user1, sentAmount);
        controller.transfer(user1, user2, sentAmount);
        assertEq(controller.balanceOf(user2), sentAmount);
        assertEq(controller.balanceOf(user1), 0);
        assertEq(controller.balanceOf(controller), issuedAmount - sentAmount);
    }

    function testValidTransferFrom() logs_gas {
        uint sentAmount = 250;
        controller.transfer(controller, user1, sentAmount);
        controller.approve(user1, controller, sentAmount);
        controller.transferFrom(controller, user1, user2, sentAmount);
        assertEq(controller.balanceOf(user2), sentAmount);
        assertEq(controller.balanceOf(user1), 0);
    }

    function testTransferTriggersEvent() {
        uint sentAmount = 250;
        expectEventsExact(frontend);
        Transfer(controller, user1, sentAmount);
        controller.transfer(controller, user1, sentAmount);
    }

    function testApproveTriggersEvent() {
        uint sentAmount = 250;
        expectEventsExact(frontend);
        Approval(controller, user1, sentAmount);
        controller.approve(controller, user1, sentAmount);
    }

    function testFailUnapprovedTransferFrom() logs_gas {
        uint sentAmount = 250;
        controller.transfer(controller, user1, sentAmount);
        controller.transferFrom(controller, user1, user2, sentAmount);
    }

    function testFailInsufficientFundsTransfer() logs_gas {
        uint sentAmount = 250;
        controller.transfer(controller, user1, issuedAmount);
        controller.transfer(user1, user2, issuedAmount+1);
    }

    function testFailInsufficientFundsTransferFrom() logs_gas {
        uint sentAmount = 250;
        controller.transfer(controller, user1, sentAmount);
        controller.approve(user1, user2, sentAmount + 1);
        controller.transferFrom(user2, user1, user2, sentAmount + 1);
    }

    function testApproveSetsAllowance() logs_gas {
        controller.approve(user1, user2, 25);
        assertEq(controller.allowance(user1, user2), 25,
                 "wrong allowance");
    }

    function testFailTransferFromWithoutApproval() logs_gas {
        controller.transfer(controller, user1, 50);
        controller.transferFrom(controller, user1, user2, 1);
    }

    function testFailChargeMoreThanApproved() logs_gas {
        controller.transfer(controller, user1, 50);
        controller.approve(user1, controller, 20);
        controller.transferFrom(controller, user1, user2, 21);
    }
}
