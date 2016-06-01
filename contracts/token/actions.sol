import 'dev/controller.sol'; // DSAction

import 'data/balance_db.sol';
import 'data/approval_db.sol';
import 'token/frontend.sol';

// Implements all actions the same way as old controller-based system (using _caller argument)
// ie, it still requires a DSTokenFrontend contract
contract DSLegacyTokenSystemMultiAction is DSAction, DSSafeAddSub {
    bytes32 constant _baldb = "baldb";
    bytes32 constant _apprdb = "apprdb";
    bytes32 constant _frontend = "frontend";
    function totalSupply() // constant returns (uint supply )
        action
    {
        var balances = DSBalanceDB(getEnv(_baldb));
        setReturn(bytes32(balances.getSupply()));
    }
    function balanceOf( address who ) // constant returns (uint balance)
        action
    {
        var balances = DSBalanceDB(getEnv(_baldb));
        setReturn(bytes32(balances.getBalance(who)));
    }
    function allowance(address owner, address spender) // constant returns (uint approval)
        action
    {
        var approvals = DSApprovalDB(getEnv(_apprdb));
        setReturn(bytes32(approvals.getApproval(owner, spender)));
    }
    // `getSender` is the old frontend! use _caller
    function transfer( address _caller, address to, uint value) // returns (bool ok)
        action
    {
        var balances = DSBalanceDB(getEnv(_baldb));
        var frontend = DSTokenFrontend(getEnv(_frontend));
        if( balances.getBalance(_caller) < value ) {
            throw;
        }
        if( !safeToAdd(balances.getBalance(to), value) ) {
            throw;
        }
        balances.moveBalance(_caller, to, value);
        frontend.emitTransfer( _caller, to, value );
        setReturn(true);
    }
    function transferFrom( address _caller, address from, address to, uint value) // returns (bool ok)
        action
    {
        var approvals = DSApprovalDB(getEnv(_apprdb));
        var balances = DSBalanceDB(getEnv(_baldb));
        var frontend = DSTokenFrontend(getEnv(_frontend));

        var from_balance = balances.getBalance( from );
        // if you don't have enough balance, throw
        if( balances.getBalance(from) < value ) {
            throw;
        }

        // if you don't have approval, throw
        var allowance = approvals.getApproval( from, _caller );
        if( allowance < value ) {
            throw;
        }

        if( !safeToAdd(balances.getBalance(to), value) ) {
            throw;
        }
        approvals.setApproval( from, _caller, allowance - value );
        balances.moveBalance( from, to, value);
        frontend.emitTransfer( from, to, value );
        setReturn(true);
    }
    function approve( address _caller, address spender, uint value) //returns (bool ok);
        action
    {
        var approvals = DSApprovalDB(getEnv(_apprdb));
        var frontend = DSTokenFrontend(getEnv(_frontend));
        approvals.setApproval( _caller, spender, value );
        frontend.emitApproval( _caller, spender, value);
        setReturn(true);
    }
}
