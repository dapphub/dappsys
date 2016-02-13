import 'dapple/test.sol';
import 'factory/factory_test.sol';
import 'token/token_test.sol';
import 'token/token.sol';
import 'token/erc20.sol';

contract DSTokenBasicSystemTest is TestFactoryUser, DSTokenTest, ERC20Events {
    DSBasicAuthority auth;

    DSBalanceDB balanceDB;
    DSApprovalDB approvalDB;
    DSTokenController controller;
    DSTokenFrontend frontend;

    function createToken() internal returns (DSToken) {
        auth = factory.buildDSBasicAuthority();
        auth.updateAuthority(address(factory), DSAuthModes.Owner);
        frontend = factory.installDSTokenBasicSystem(auth);
        return frontend;
    }

    function setUp() {
        // Save system sub-pieces
        controller = DSTokenFrontend(token).getController();
        balanceDB = controller.getBalanceDB();
        approvalDB = controller.getApprovalDB();

        // satisfy the precondition
        var sig = bytes4(sha3("setBalance(address,uint256)"));
        auth.setCanCall(this, balanceDB, sig, true);
        balanceDB.setBalance(this, initialBalance);
        auth.setCanCall(this, balanceDB, sig, false);

        // Additionally, let the test harness call the controller directly,
        // as if the tester were the frontend.
        auth.setCanCall(this, controller, "transfer(address,address,uint256)", true);
        auth.setCanCall(this, controller, "transferFrom(address,address,address,uint256)", true);
        auth.setCanCall(this, controller, "approve(address,address,uint256)", true);
    }
    function testBalanceAuth() {
        assertTrue( balanceDB._authority() == address(auth));
        assertTrue( balanceDB._auth_mode() == DSAuthModes.Authority );
    }
    function testTestHarnessAuth() {
        assertTrue( auth._authority() == address(this) );
        assertTrue( auth._auth_mode() == DSAuthModes.Owner );
    }

    function testGetController() {
        assertEq(frontend.getController(), controller);
    }

    function testSetController() {
        var newController = new DSTokenController(frontend, balanceDB, approvalDB);
        auth.setCanCall(this, frontend, "setController(address)", true);
        frontend.setController(newController);
        assertEq(frontend.getController(), newController);
    }

    function testGetFrontend() {
        assertEq(address(controller.getFrontend()), address(frontend));
    }

    function testSetFrontend() {
        var newFrontend = new DSTokenFrontend();
        auth.setCanCall(this, controller, "setFrontend(address)", true);
        controller.setFrontend(newFrontend);
        assertEq(address(controller.getFrontend()), address(newFrontend));
    }

    function testGetApprovalDb() {
        var _approvalDB = controller.getApprovalDB();
        assertEq(address(_approvalDB), address(_approvalDB));
    }

    function testSetApprovalDb() {
        var newApprovalDB = new DSApprovalDB();
        auth.setCanCall(address(this), controller, "setApprovalDB(address)", true);
        controller.setApprovalDB(newApprovalDB);
        assertEq(controller.getApprovalDB(), newApprovalDB, "db not set");
    }

    function testGetBalanceDb() {
        var _balanceDB = controller.getBalanceDB();
        assertEq(address(_balanceDB), address(_balanceDB));
    }

    function testSetBalanceDb() {
        var newBalanceDB = new DSBalanceDB();
        auth.setCanCall(address(this), controller, "setBalanceDB(address)", true);
        controller.setBalanceDB(newBalanceDB);
        assertEq(controller.getBalanceDB(), newBalanceDB, "db not set");
    }


    // Functionality directly on the controller
    function testAllowanceStartsAtZero() logs_gas {
        assertEq(controller.allowance(user1, user2), 0);
    }

    function testBalanceOfStartsAtZero() logs_gas {
        assertEq(controller.balanceOf(user1), 0);
    }

    function testBalanceOfReflectsTransfer() logs_gas {
        uint sentAmount = 250;
        controller.transfer(this, user1, sentAmount);
        assertEq(controller.balanceOf(user1), sentAmount);
    }

    function testTotalSupply() logs_gas {
        assertEq(controller.totalSupply(), initialBalance);
    }

    function testControllerValidTransfers() logs_gas {
        uint sentAmount = 250;
        controller.transfer(this, user1, sentAmount);
        controller.transfer(user1, user2, sentAmount);
        assertEq(controller.balanceOf(user2), sentAmount);
        assertEq(controller.balanceOf(user1), 0);
        assertEq(controller.balanceOf(this), initialBalance - sentAmount);
    }

    function testControllerValidTransferFrom() logs_gas {
        uint sentAmount = 250;
        controller.transfer(this, user1, sentAmount);
        controller.approve(user1, this, sentAmount);
        controller.transferFrom(this, user1, user2, sentAmount);
        assertEq(controller.balanceOf(user2), sentAmount);
        assertEq(controller.balanceOf(user1), 0);
    }

    function testControllerTransferTriggersEvent() {
        uint sentAmount = 250;
        expectEventsExact(frontend);
        Transfer(this, user1, sentAmount);
        controller.transfer(this, user1, sentAmount);
    }

    function testControllerApproveTriggersEvent() {
        uint sentAmount = 250;
        expectEventsExact(frontend);
        Approval(this, user1, sentAmount);
        controller.approve(this, user1, sentAmount);
    }

    function testFailControllerUnapprovedTransferFrom() logs_gas {
        uint sentAmount = 250;
        controller.transfer(this, user1, sentAmount);
        controller.transferFrom(this, user1, user2, sentAmount);
    }

    function testFailControllerInsufficientFundsTransfer() logs_gas {
        uint sentAmount = 250;
        controller.transfer(this, user1, initialBalance);
        controller.transfer(user1, user2, initialBalance+1);
    }

    function testFailControllerInsufficientFundsTransferFrom() logs_gas {
        uint sentAmount = 250;
        controller.transfer(this, user1, sentAmount);
        controller.approve(user1, user2, sentAmount + 1);
        controller.transferFrom(user2, user1, user2, sentAmount + 1);
    }

    function testControllerApproveSetsAllowance() logs_gas {
        controller.approve(user1, user2, 25);
        assertEq(controller.allowance(user1, user2), 25,
                 "wrong allowance");
    }

    function testFailControllerTransferFromWithoutApproval() logs_gas {
        controller.transfer(this, user1, 50);
        controller.transferFrom(this, user1, user2, 1);
    }

    function testFailControllerChargeMoreThanApproved() logs_gas {
        controller.transfer(this, user1, 50);
        controller.approve(user1, this, 20);
        controller.transferFrom(this, user1, user2, 21);
    }




}
