// Balance database contract for Tokens.
// Note that `add_balance` checks for overflow, but `move_balance` does not.
// That means this interface makes the assumption that all balances were added
// using `add_balance` - there are implicit semantics.
// TODO why not both one way or the other?
import 'auth/auth.sol';

contract DSBalanceDB is DSAuth {
    uint _supply;
    mapping( address => uint )  _balances;
    function get_supply()
             constant
             returns (uint, bool)
    {
        return (_supply, true);
    }
    function get_balance( address who )
             constant
             returns (uint, bool)
    {
        return (_balances[who], true);
    }
    function add_balance( address to, uint amount )
             auth()
             returns (bool success)
    {
        if( _supply + amount < _supply ) {
            return false;
        }
        _balances[to] += amount;
        _supply += amount;
        changed_balance( to, amount, true );
        return true;
    }
    function sub_balance( address from, uint amount )
             auth()
             returns (bool success)
    {
        if( _balances[from] < amount ) {
            return false;
        }
        _balances[from] -= amount;
        _supply -= amount;
        changed_balance( from, amount, false );
        return true;
    }
    function move_balance( address from, address to, uint amount )
             auth()
             returns (bool success)
    {
        if( _balances[from] < amount ) {
            return false;
        }
        _balances[from] -= amount;
        _balances[to] += amount;
        changed_balance( from, amount, false );
        changed_balance( to, amount, true );
        return true;
    }
    event changed_balance( address who, uint amount, bool positive);
}
