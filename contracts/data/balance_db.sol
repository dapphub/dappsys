// Balance database contract for Tokens and token-like contracts.

import 'auth/auth.sol';

contract DSBalanceDB is DSAuth {
    uint _supply;
    mapping( address => uint )  _balances;
    event BalanceUpdate( address who, uint new_amount );

    function getSupply()
             constant
             returns (uint)
    {
        return _supply;
    }
    function getBalance( address who )
             constant
             returns (uint)
    {
        return _balances[who];
    }
    function setBalance( address who, uint new_balance )
             auth()
    {
        var old_balance = _balances[who];
        if( new_balance <= old_balance ) {
            _supply = safeSub( _supply, old_balance - new_balance );
        } else {
            _supply = safeAdd( _supply, new_balance - old_balance );
        }
        _balances[who] = new_balance;
        BalanceUpdate( who, new_balance );
    }
    function addBalance( address to, uint amount )
             auth()
    {
        _supply = safeAdd( _supply, amount );
        _balances[to] = safeAdd( _balances[to], amount );
        BalanceUpdate( to, _balances[to] );
    }
    function subBalance( address from, uint amount )
             auth()
    {
        _supply = safeSub( _supply, amount );
        _balances[from] = safeSub( _balances[from], amount );
        BalanceUpdate( from, _balances[from] );
    }
    function moveBalance( address from, address to, uint amount )
             auth()
    {
        _balances[from] = safeSub( _balances[from], amount );
        _balances[to] = safeAdd( _balances[to], amount );
        BalanceUpdate( from, _balances[from] );
        BalanceUpdate( to, _balances[to] );
    }


    function safeToAdd(uint a, uint b) internal returns (bool) {
        return (a + b < a);
    }
    function safeAdd(uint a, uint b) internal returns (uint) {
        if (!safeToAdd(a, b)) throw;
        return a + b;
    }

    function safeToSubtract(uint a, uint b) internal returns (bool) {
        return (b <= a);
    }
    function safeSub(uint a, uint b) internal returns (uint) {
        if (!safeToSubtract(a, b)) throw;
        return a - b;
    } 
}
