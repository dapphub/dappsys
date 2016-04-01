import 'auth.sol';

import 'data/balance_db.sol';
import 'data/approval_db.sol';

import 'token/controllers/base.sol';
import 'token/hooks/types.sol';

import 'util/safety.sol';


contract DSConfigurableTokenController is DSTokenController {
    DSTokenSystemTransferHookType[] transfer_hooks;
    DSTokenSystemTransferFromHookType[] transferFrom_hooks;
    DSTokenSystemApproveHookType[] approve_hooks;

    function transfer( address _caller, address to, uint value )
             auth() 
             returns (bool)
    {
        for(var i = 0; i < transfer_hooks.length; i++ ) {
            var ok = transfer_hooks[i].transfer( _caller, to, value );
            if( !ok ) {
                throw;
            }
        }
        return true;
    }
    function transferFrom( address _caller, address from, address to, uint value )
             auth()
             returns (bool)
    {
        for(var i = 0; i < transferFrom_hooks.length; i++ ) {
            var ok = transferFrom_hooks[i].transferFrom( _caller, from, to, value );
            if( !ok ) {
                throw;
            }
        }
        return true;

    }
    function approve( address _caller, address spender, uint value)
             auth()
             returns (bool)
    {
        for(var i = 0; i < approve_hooks.length; i++ ) {
            var ok = approve_hooks[i].approve( _caller, spender, value );
            if( !ok ) {
                throw;
            }
        }
        return true;
    }

    function setTransferHook( uint8 index, DSTokenSystemTransferHookType hook )
             auth()
    {
        transfer_hooks[index] = hook;
    }
    function setTransferFromHook( uint8 index, DSTokenSystemTransferFromHookType hook )
             auth()
    {
        transferFrom_hooks[index] = hook;
    }
    function setApproveHook( uint8 index, DSTokenSystemApproveHookType hook )
             auth()
    {
        approve_hooks[index] = hook;
    }

}

