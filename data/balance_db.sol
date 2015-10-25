import 'auth/auth.sol';
// TODO check it does direct-map, otherwise static auth trick isn't worth it

// An optimized address-to-uint-balance base class
// Uses static auth version as a hack to get state variables
// ordered for addresses to map directly to their balances in storage
contract DSBalanceDB is DSStaticAuth {
    uint[2**160] _balances;
    uint public supply;
    address public _ds_authority;
    function DSBalanceDB( address authority ) {
        _ds_authority = authority;
    }
    function get_balance( address who )
             constant
             returns (uint, bool)
    {
        return (_balances[uint(bytes20(who))], true);
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
    function move_balance( address from, address to, uint amount )
             static_auth( _ds_authority )
             returns (bool success)
    {
        if( _balances[uint(bytes20(from))] < amount ) {
            return false;
        }
        _balances[uint(bytes20(from))] -= amount;
        _balances[uint(bytes20(to))] += amount;
        return true;
    }
}
