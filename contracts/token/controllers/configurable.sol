import 'auth.sol';

import 'data/balance_db.sol';
import 'data/approval_db.sol';

import 'token/controllers/base.sol';
import 'token/hooks/types.sol';

import 'util/safety.sol';


contract DSConfigurableTokenController is DSTokenController {
    DSTokenSystemTransferHookType[] transfer_actions;
    DSTokenSystemTransferFromHookType[] transferFrom_actions;
    DSTokenSystemApproveHookType[] approve_actions;

    function transfer( address _frontend_caller, address to, uint value )
             auth() 
             returns (bool ok)
    {
        for(var i = 0; i < transfer_actions.length; i++ ) {
            ok = transfer_actions[i].transfer( _frontend_caller, to, value );
            if( !ok ) {
                throw;
            }
        }
        return true;
    }
    function setTransferHook( uint8 index, DSTokenSystemTransferHookType action ) auth() {
        transfer_actions[index] = action;
    }
}

