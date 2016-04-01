import 'auth.sol';

import 'data/balance_db.sol';
import 'data/approval_db.sol';

import 'token/controller.sol';

import 'util/safety.sol';


// Sub-actions to be run on stateful token function calls
contract DSTokenSystemTransferActionType {
    function transfer( address _frontend_caller, address to, uint value ) returns (bool ok);
}
contract DSTokenSystemTransferFromActionType {
    function transferFrom( address _frontend_caller, address from, address to, uint value ) returns (bool ok);
}
contract DSTokenSystemApproveActionType {
    function approve( address _frontend_caller, address to, uint value ) returns (bool ok);
}

// implements the business logic of the original token controller
contract DSTokenControllerDefaultActions is DSAuth
    , DSTokenSystemTransferActionType
    , DSTokenSystemTransferFromActionType
    , DSTokenSystemApproveActionType
    , DSSafeAddSub
{
    DSTokenControllerType _parent;

    function DSTokenControllerDefaultActions( DSTokenControllerType parent_controller )
    {
        _parent = parent_controller;
    }
    function transfer( address _frontend_caller, address to, uint value )
             auth()
             returns (bool ok)
    {
        var balances = _parent.getBalanceDB();
        var approvals = _parent.getApprovalDB();
        var frontend = _parent.getFrontend();

        if( balances.getBalance(_frontend_caller) < value ) {
            throw;
        }
        if( !safeToAdd(balances.getBalance(to), value) ) {
            throw;
        }
        balances.moveBalance(_frontend_caller, to, value);
        frontend.emitTransfer( _frontend_caller, to, value );
        return true;
    }
    function transferFrom(address _frontend_caller, address from, address to, uint value)
             auth()
             returns (bool)
    {
        var balances = _parent.getBalanceDB();
        var approvals = _parent.getApprovalDB();
        var frontend = _parent.getFrontend();


        var from_balance = balances.getBalance( from );
        // if you don't have enough balance, throw
        if( from_balance < value ) {
            throw;
        }

        // if you don't have approval, throw
        var allowance = approvals.getApproval( from, _frontend_caller );
        if( allowance < value ) {
            throw;
        }

        if( !safeToAdd(balances.getBalance(to), value) ) {
            throw;
        }
        approvals.setApproval( from, _frontend_caller, allowance - value );
        balances.moveBalance( from, to, value);
        frontend.emitTransfer( from, to, value );
        return true;
    }
    function approve( address _frontend_caller, address spender, uint value)
             auth()
             returns (bool)
    {
        var approvals = _parent.getApprovalDB();
        var frontend = _parent.getFrontend();

        approvals.setApproval( _frontend_caller, spender, value );
        frontend.emitApproval( _frontend_caller, spender, value);
    }

}


contract DSConfigurableTokenController is DSTokenController {
    DSTokenSystemTransferActionType[] transfer_actions;
    DSTokenSystemTransferFromActionType[] transferFrom_actions;
    DSTokenSystemApproveActionType[] approve_actions;

    function transfer( address _frontend_caller, address to, uint value ) auth() returns (bool ok)
    {
        for(var i = 0; i < transfer_actions.length; i++ ) {
            ok = transfer_actions[i].transfer( _frontend_caller, to, value );
            if( !ok ) {
                throw;
            }
        }
        return true;
    }
    function setTransferHook( uint8 index, DSTokenSystemTransferActionType action ) auth() {
        transfer_actions[index] = action;
    }
}

