contract DSBalanceDB { // is DSAuth {
    address _ds_authority;
    uint[2**160] _balances;

    function get_balance( address who )
             constant
             returns (uint, bool)
    {
        return (_balances[uint(bytes20(who))], true);
    }
    function add_balance( address to, uint amount )
             auth()
             returns (bool success)
    {
        if( _supply + amount < _supply ) {
            return false;
        }
        _balances[uint(bytes20(to))] += amount;
        _supply += amount;
        return true;
    }
    function sub_balance( address from, uint amount )
             auth()
             returns (bool success)
    {
        if( _balances[uint(bytes20(from))] < amount ) {
            return false;
        }
        _balances[uint(bytes20(from))] -= amount;
        _supply -= amount;
        return true;
    }
    function move_balance( address from, address to, uint amount )
             auth()
             returns (bool success)
    {
        if( _balances[uint(bytes20(from))] < amount ) {
            return false;
        }
        _balances[uint(bytes20(from))] -= amount;
        _balances[uint(bytes20(to))] += amount;
        return true;
    }


/*
    function _ds_get_authority() constant returns (address authority, bool ok) {
        return (_ds_authority, true);
    }
    function _ds_update_authority( address new_authority )
             auth()
             returns (bool success)
    {
        _ds_authority = DSAuthority(new_authority);
        return true;
    }

    modifier auth() {
        if( _ds_authenticated() ) {
            _
        }
    }
    function _ds_authenticated() internal returns (bool is_authenticated) {
        if( msg.sender == _ds_authority ) {
            return true;
        }
        var A = DSAuthority(_ds_authority);
        return A.can_call( msg.sender, address(this), msg.sig );
    }
*/



}
