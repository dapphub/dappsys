import 'dapple/test.sol';
import 'token/base.sol';
import 'token/user.sol';
import 'token/registry.sol';

contract TokenProviderUserTester is Tester {
    DSTokenBase token;

    function TokenProviderUserTester(DSTokenBase _token) {
        token = _token;
    }

    function doApprove(address to, uint amount) returns (bool) {
        return token.approve(to, amount);
    }
}

contract TokenProviderUserTest is Test,
        DSTokenProviderUser(DSTokenProvider(0x0)) {
    uint constant issuedAmount = 1000;
    bytes32 constant tokenName = "Dogecoin";

    DSTokenBase token;
    TokenProviderUserTester user1;
    TokenProviderUserTester user2;

    function setUp() {
        _tokens = new DSTokenRegistry();
        token = new DSTokenBase(issuedAmount);
        DSTokenRegistry(_tokens).set(tokenName, bytes32(address(token)));

        user1 = new TokenProviderUserTester(token);
        user2 = new TokenProviderUserTester(token);
        user1._target(this);
        user2._target(this);
    }

    function testGetToken() {
        assertEq(getToken(tokenName), token);
    }

    function testTotalSupply() {
        assertEq(totalSupply(tokenName), issuedAmount);
    }

    function testAllowanceStartsAtZero() logs_gas {
        assertEq(allowance(user1, user2, tokenName), 0);
    }

    function testValidTransfers() logs_gas {
        uint sentAmount = 250;
        transfer(user1, sentAmount, tokenName);
        assertEq(balanceOf(user1, tokenName), sentAmount);
        assertEq(balanceOf(this, tokenName), issuedAmount - sentAmount);
    }

    function testFailInsufficientFundsTransfers() logs_gas {
        uint sentAmount = 250;
        transfer(user1, sentAmount, tokenName);
        transferFrom(user1, user2, sentAmount+1, tokenName);
    }

    function testApproveSetsAllowance() logs_gas {
        approve(user1, 25, tokenName);
        assertEq(allowance(this, user1, tokenName), 25,
                 "wrong allowance");
    }

    function testChargesAmountApproved() logs_gas {
        uint amountApproved = 20;
        user1.doApprove(this, amountApproved);
        transfer(user1, issuedAmount, tokenName);
        assertTrue(transferFrom(user1, user2, amountApproved, tokenName),
            "couldn't transferFrom");
        assertEq(balanceOf(user1, tokenName), issuedAmount - amountApproved,
             "wrong balance after transferFrom");
    }

    function testFailUnapprovedTransfers() logs_gas {
        uint sentAmount = 250;

        transfer(user1, issuedAmount, tokenName);
        transferFrom(user1, user2, sentAmount, tokenName);
    }

    function testFailChargeMoreThanApproved() logs_gas {
        approve(user1, 20, tokenName);
        transferFrom(this, user1, 21, tokenName);
    }
}
