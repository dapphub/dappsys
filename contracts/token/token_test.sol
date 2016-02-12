import 'auth.sol';
import 'dapple/test.sol';
import 'dapple/debug.sol';
import 'token/base.sol';
import 'auth/authority.sol';
import 'factory/factory.sol';
import 'factory/factory_test.sol';

// Supporting classes

contract DSTokenTester is Tester, Debug {
    function doTransferFrom(address from, address to, uint amount)
        returns (bool)
    {
        return DSToken(_t).transferFrom(from, to, amount);
    }

    function doTransfer(address to, uint amount)
        returns (bool)
    {
        return DSToken(_t).transfer(to, amount);
    }

    function doApprove(address recipient, uint amount)
        returns (bool)
    {
        return DSToken(_t).approve(recipient, amount);
    }

    function doAllowance(address owner, address spender)
        constant returns (uint)
    {
        return DSToken(_t).allowance(owner, spender);
    }

    function doBalanceOf(address who) constant returns (uint) {
        return DSToken(_t).balanceOf(who);
    }
}

// Actual tests

contract DSTokenTest is Test, DSAuthUser {
    uint constant initialBalance = 1000;

    DSToken token;
    DSTokenTester user1;
    DSTokenTester user2;

    function DSTokenTest() {
        token = createToken();
        user1 = new DSTokenTester();
        user2 = new DSTokenTester();
        user1._target(address(token));
        user2._target(address(token));
    }

    function createToken() internal returns (DSToken) {
        return new DSTokenBase(initialBalance);
    }

    function initUserBalance() {
        token.transfer(user1, initialBalance);
    }

    function testSetupPrecondition() {
        assertEq(token.balanceOf(this), initialBalance);
    }

    function testInitUserBalance() {
        assertEq(token.balanceOf(this), initialBalance);
        initUserBalance();
        assertEq(token.balanceOf(this), 0);
        assertEq(token.balanceOf(user1), initialBalance);
    }

    function testTransferCost() logs_gas() {
        token.transfer(address(0), 10);
    }

    function testAllowanceStartsAtZero() logs_gas {
        assertEq(user1.doAllowance(user1, user2), 0);
    }

    function testValidTransfers() logs_gas {
        initUserBalance();

        uint sentAmount = 250;
        user1.doTransfer(user2, sentAmount);
        assertEq(user2.doBalanceOf(user2), sentAmount);
        assertEq(user1.doBalanceOf(user1), initialBalance - sentAmount);
    }

    function testFailWrongAccountTransfers() logs_gas {
        initUserBalance();

        uint sentAmount = 250;
        user1.doTransferFrom(user2, user1, sentAmount);
    }

    function testFailInsufficientFundsTransfers() logs_gas {
        initUserBalance();

        uint sentAmount = 250;
        token.transfer(user1, initialBalance);
        user1.doTransfer(user2, initialBalance+1);
    }

    function testApproveSetsAllowance() logs_gas {
        log_named_address("Test", this);
        log_named_address("Token", token);
        log_named_address("User 1", user1);
        log_named_address("User 2", user2);
        user1.doApprove(user2, 25);
        assertEq(user1.doAllowance(user1, user2), 25,
                 "wrong allowance");
    }

    function testChargesAmountApproved() logs_gas {
        initUserBalance();

        uint amountApproved = 20;
        user1.doApprove(user2, amountApproved);
        assertTrue(user2.doTransferFrom(
            user1, user2, amountApproved),
            "couldn't transferFrom");
        assertEq(user1.doBalanceOf(user1), initialBalance - amountApproved,
                 "wrong balance after transferFrom");
    }

    function testFailTransferWithoutApproval() logs_gas {
        initUserBalance();

        address self = this;
        token.transfer(user1, 50);
        token.transferFrom(user1, self, 1);
    }

    function testFailChargeMoreThanApproved() logs_gas {
        initUserBalance();

        address self = this;
        token.transfer(user1, 50);
        user1.doApprove(self, 20);
        token.transferFrom(user1, self, 21);
    }
}

contract DSTokenSystemTest is TestFactoryUser, DSTokenTest {
    DSBasicAuthority auth;

    function createToken() internal returns (DSToken) {
        auth = factory.buildDSBasicAuthority();
        auth.updateAuthority(address(factory), DSAuthModes.Owner);
        return factory.buildDSTokenBasicSystem(auth);
    }

    function setUp() {
        // satisfy the precondition
        var baldb = DSTokenFrontend(token).getController().getBalanceDB();
        var sig = bytes4(sha3("setBalance(address,uint256)"));
        auth.setCanCall(this, baldb, sig, true);
        baldb.setBalance(this, initialBalance);
        auth.setCanCall(this, baldb, sig, false);
    }
    function testBalanceAuth() {
        var baldb = DSTokenFrontend(token).getController().getBalanceDB();
        assertTrue(baldb._authority() == address(auth));
        assertTrue( baldb._auth_mode() == DSAuthModes.Authority );
    }
    function testOwnAuth() {
        assertTrue( auth._authority() == address(this) );
        assertTrue( auth._auth_mode() == DSAuthModes.Owner );
    }
    function testApproveSetsAllowance() logs_gas() {
        log_named_address("auth", auth);
        super.testApproveSetsAllowance();
    }
}
