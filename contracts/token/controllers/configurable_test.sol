import 'token/token_test.sol';
import 'factory/factory_test.sol';

import 'token/controllers/configurable.sol';

import 'auth.sol';


contract DSTokenConfigurableSystemTest is DSTokenTest, TestFactoryUser
{
    DSBasicAuthority auth;

    DSBalanceDB _balances;
    DSApprovalDB _approvals;
    DSTokenFrontend _frontend;

    DSConfigurableTokenController _cont;

    function DSTokenConfigurableSystemTest() {
    }

    function setUp() {
        token = createToken();
        auth.setCanCall(this, _balances, "setBalance(address,uint256)", true);
        _balances.setBalance(this, 1000);
        auth.setCanCall(this, _balances, "setBalance(address,uint256)", false);

        // re-target testers TODO figure all this out
        user1._target(address(token));
        user2._target(address(token));

    }

    function createToken() internal returns (DSToken) {
        auth = factory.buildDSBasicAuthority();
        _frontend = factory.buildDSTokenFrontend();
        _balances = factory.buildDSBalanceDB();
        _approvals = factory.buildDSApprovalDB();
        
        _cont = new DSConfigurableTokenController( _frontend, _balances, _approvals );
        _frontend.setController( _cont );

        var default_transfer = new DSTokenDefaultTransferHook(_cont);
        var default_transferFrom = new DSTokenDefaultTransferFromHook(_cont);
        var default_approve = new DSTokenDefaultApproveHook(_cont);

        _cont.setTransferHook(0, default_transfer);
        _cont.setTransferFromHook(0, default_transferFrom);
        _cont.setApproveHook(0, default_approve);

        auth.setCanCall(default_transfer, _balances, "moveBalance(address,address,uint256)", true);
        auth.setCanCall(default_transfer, _frontend, "emitTransfer(address,address,uint256)", true);

        auth.setCanCall(default_transferFrom, _approvals, "setApproval(address,address,uint256)", true);
        auth.setCanCall(default_transferFrom, _balances, "moveBalance(address,address,uint256)", true);
        auth.setCanCall(default_transferFrom, _frontend, "emitTransfer(address,address,uint256)", true);

        auth.setCanCall(default_approve, _approvals, "setApproval(address,address,uint256)", true);
        auth.setCanCall(default_approve, _frontend, "emitApproval(address,address,uint256)", true);

        auth.setCanCall(_frontend, _cont, "transfer(address,address,uint256)", true);
        auth.setCanCall(_frontend, _cont, "transferFrom(address,address,address,uint256)", true);
        auth.setCanCall(_frontend, _cont, "approve(address,address,uint256)", true);

        auth.setCanCall(_cont, default_transfer, "transfer(address,address,uint256)", true);
        auth.setCanCall(_cont, default_transferFrom, "transferFrom(address,address,address,uint256)", true);
        auth.setCanCall(_cont, default_approve, "approve(address,address,uint256)", true);
        
        setAuthority(_balances, auth);
        setAuthority(_approvals, auth);
        setAuthority(_frontend, auth);
        setAuthority(_cont, auth);
        setAuthority(default_transfer, auth);
        setAuthority(default_transferFrom, auth);
        setAuthority(default_approve, auth);

        return _frontend;
    }

}

