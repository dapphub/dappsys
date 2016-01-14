// Balance database contract for Tokens.
// Note that `add_balance` checks for overflow, but `move_balance` does not.
// That means this interface makes the assumption that all balances were added
// using `add_balance` - there are implicit semantics.
// TODO why not both one way or the other?
import 'auth/auth.sol';

contract DSBalanceDB is DSAuth {
    uint _supply;
    mapping( address => uint )  _balances;
    function getSupply()
             constant
             returns (uint, bool)
    {
        return (_supply, true);
    }
    function getBalance( address who )
             constant
             returns (uint, bool)
    {
        return (_balances[who], true);
    }
    function addBalance( address to, uint amount )
             auth()
             returns (bool success)
    {
        if( _supply + amount < _supply ) {
            return false;
        }
        _balances[to] += amount;
        _supply += amount;
        BalanceChanged( to, amount, true );
        return true;
    }
    function subBalance( address from, uint amount )
             auth()
             returns (bool success)
    {
        if( _balances[from] < amount ) {
            return false;
        }
        _balances[from] -= amount;
        _supply -= amount;
        BalanceChanged( from, amount, false );
        return true;
    }
    function moveBalance( address from, address to, uint amount )
             auth()
             returns (bool success)
    {
        if( _balances[from] < amount ) {
            return false;
        }
        _balances[from] -= amount;
        _balances[to] += amount;
        BalanceChanged( from, amount, false );
        BalanceChanged( to, amount, true );
        return true;
    }
    event BalanceChanged( address who, uint amount, bool positive);
}

contract DSBalanceDBFactory {
    function build() returns (DSBalanceDB) {
        var db = new DSBalanceDB();
        db.updateAuthority(msg.sender, false);
        return db;
    }
}
