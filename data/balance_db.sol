import 'auth/auth.sol';

// An optimized address-to-uint-balance base class
// Uses static auth version as a hack to get state variables
// ordered for addresses to map directly to their balances in storage
contract DSBalanceDB is DSStaticAuth {
    uint[2**160] _balances;
    uint public supply;
    address public _ds_authority;
    function get_balance( address who )
             constant
             returns (uint)
    {
        return _balances[uint(bytes20(who))];
    }
    function add_balance( address to, uint amount )
             static_auth( _ds_authority )
             returns (bool success)
    {
        if( supply + amount < supply ) {
            return false;
        }
        _balances[uint(bytes20(to))] += amount;
        supply += amount;
        return true;
    }
    function sub_balance( address from, uint amount )
             static_auth( _ds_authority )
             returns (bool success)
    {
        if( _balances[uint(bytes20(from))] < amount ) {
            return false;
        }
        _balances[uint(bytes20(from))] -= amount;
        supply -= amount;
        return true;
    }

}
