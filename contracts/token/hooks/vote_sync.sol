import 'auth.sol';
import 'token/hooks/types.sol';
import 'token/controllers/default.sol';

contract DSTokenBalanceVoteSyncHook is DSAuth
    , DSTokenDefaultApproveHook
    , DSTokenSystemTransferHookType
{
    DSTokenConfigurableControllerType _parent;
    function DSTokenBalanceVoteSyncHook( DSTokenConfigurableControllerType parent )
             DSTokenDefaultApproveHook( parent )
    {
        _parent = parent;
    }
    
    function transfer(address _caller, address to, uint value)
             auth()
             returns (bool)
    {
        var _balances = _parent.getBalanceDB();
        var _votes = _parent.getLocalRef("vote_db");
        var max_vote = _balances.getBalance(_caller);
        var vote = _votes.getVote(_caller);
        if( vote > max_vote ) {
            vote = max_vote;
        }
        _votes.setVote( vote );
        return true;
    }
    function transferFrom(address _caller, address from, address to, uint value)
             auth()
             returns (bool)
    {
        var _balances = _parent.getBalance();
        var _votes = _parent.getLocalRef("vote_db");
        var max_vote = _balances.getBalance(_caller);
        var vote = _votes.getVote(_caller);
        if( vote > max_vote ) {
            vote = max_vote;
        }
        _votes.setVote( vote );
        return true;
    }
}
