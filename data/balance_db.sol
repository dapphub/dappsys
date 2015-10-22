
// An optimized address-to-uint-balance base class
contract DSBalanceDB is DSAuth {
    uint public supply;
    uint[2**128] _balances;
    function get_balance( address who )
             constant
             returns (uint)
    {
        return _balances[uint128(who)];
    }
    function add_balance( address to, uint amount )
             auth()
             returns (bool success)
    {
        if( supply + amount < supply ) {
            return false;
        }
        _balances[uint128(to)] += amount;
        supply += amount;
        return true;
    }
    function sub_balance( address from, uint amount )
             auth() 
             returns (bool success)
    {
        if( _balances[uint128(from)] < amount ) {
            return false;
        }
        _balances[uint128(from)] -= amount;
        supply -= amount;
        return true;
    }

}
