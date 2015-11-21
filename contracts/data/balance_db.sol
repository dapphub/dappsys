// NOTE: add_balance checks for overflow
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
