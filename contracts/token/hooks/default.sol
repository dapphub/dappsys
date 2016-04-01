import 'auth.sol';
import 'util/safety.sol';
import 'token/hooks/types.sol';
import 'token/controllers/base.sol';

// implements the business logic of the original token controller
contract DSTokenDefaultTransferHook is DSAuth
    , DSTokenSystemTransferHookType
    , DSSafeAddSub
{
    DSTokenControllerType _parent;

    function DSTokenDefaultTransferHook( DSTokenControllerType parent_controller )
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
}

contract DSTokenDefaultTransferFromHook is DSAuth
    , DSTokenSystemTransferFromHookType
    , DSSafeAddSub
{
    DSTokenControllerType _parent;
    function DSTokenDefaultTransferFromHook( DSTokenControllerType parent_controller )
    {
        _parent = parent_controller;
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
}

contract DSTokenDefaultApproveHook is DSAuth
    , DSTokenSystemApproveHookType
{
    DSTokenControllerType _parent;
    function DSTokenDefaultApproveHook( DSTokenControllerType parent_controller )
    {
        _parent = parent_controller;
    }

    function approve( address _caller, address spender, uint value)
             auth()
             returns (bool)
    {
        var approvals = _parent.getApprovalDB();
        var frontend = _parent.getFrontend();

        approvals.setApproval( _caller, spender, value );
        frontend.emitApproval( _caller, spender, value);
    }

}
