import 'auth.sol';
import 'dapple/test.sol';
import 'token/controller.sol';
import 'token/frontend.sol';

contract TokenFrontendTester is Tester {
    function doTransferFrom(address from, address to, uint amount)
        returns (bool)
    {
        return DSTokenFrontend(_t).transferFrom(from, to, amount);
    }

    function doApprove(address recipient, uint amount)
        returns (bool)
    {
        return DSTokenFrontend(_t).approve(recipient, amount);
    }
}

contract TokenFrontendTest is Test, DSAuthUser {
    uint constant issuedAmount = 1000;

    DSBalanceDB balanceDB;
    DSApprovalDB approvalDB;
    DSTokenController controller;
    DSTokenFrontend frontend;
    TokenFrontendTester user;

    function TokenFrontendTest() {
        approvalDB = new DSApprovalDB();
        balanceDB = new DSBalanceDB();
        controller = new DSTokenController(balanceDB, approvalDB);
        frontend = new DSTokenFrontend(controller);

        var eventFrontend = new DSTokenFrontend(controller);
        eventFrontend.updateAuthority(controller, DSAuthModes.Owner);
        controller.setFrontend(eventFrontend);
    }

    function setUp() {
        user = new TokenFrontendTester();
        user._target(frontend);

        balanceDB.setBalance(this, issuedAmount);
        balanceDB.updateAuthority(controller, DSAuthModes.Owner);
        approvalDB.updateAuthority(controller,DSAuthModes.Owner);
        controller.updateAuthority(frontend, DSAuthModes.Owner);
    }

    function testGetController() {
        assertEq(frontend.getController(), controller);
    }

    function testSetController(){
        var newController = new DSTokenController(balanceDB, approvalDB);
        assertTrue(frontend.setController(newController));
        assertEq(frontend.getController(), newController);
    }

    function testAllowanceStartsAtZero() logs_gas {
        assertEq(frontend.allowance(frontend, user), 0);
    }

    function testValidTransfers() logs_gas {
        uint sentAmount = 250;
        frontend.transfer(user, sentAmount);
        assertEq(frontend.balanceOf(user), sentAmount);
        assertEq(frontend.balanceOf(this), issuedAmount - sentAmount);
    }

    function testFailWrongAccountTransfers() logs_gas {
        uint sentAmount = 250;
        frontend.transfer(user, sentAmount);
        frontend.transferFrom(user, frontend, sentAmount);
    }

    function testFailInsufficientFundsTransfers() logs_gas {
        uint sentAmount = 250;

        // Empty our account of all but `sentAmount` tokens,
        // then try sending `sentAmount + 1` tokens.
        frontend.transfer(frontend, issuedAmount - sentAmount);
        frontend.transfer(user, sentAmount + 1);
    }

    function testApproveSetsAllowance() logs_gas {
        frontend.approve(user, 25);
        assertEq(frontend.allowance(this, user), 25, "wrong allowance");
    }

    function testChargesAmountApproved() logs_gas {
        uint amountApproved = 20;
        frontend.approve(user, amountApproved);
        assertTrue(user.doTransferFrom(
            this, user, amountApproved),
            "couldn't transferFrom");
        assertEq(frontend.balanceOf(this), issuedAmount - amountApproved,
                 "wrong balance after transferFrom");
    }

    function testFailTransferWithoutApproval() logs_gas {
        frontend.transfer(user, 50);
        frontend.transferFrom(user, this, 1);
    }

    function testFailChargeMoreThanApproved() logs_gas {
        frontend.transfer(this, 50);
        user.doApprove(this, 20);
        frontend.transferFrom(user, this, 21);
    }

}
