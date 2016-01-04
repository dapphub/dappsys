// User mixin contract for working with single fixed ERC20 tokens.
// TODO code generation for multi-address checks.
import 'token/token.sol';

contract DSTokenUser {
    DSToken _t;
    function DSTokenUser( DSToken t ) {
        _t = t;
    }
    // Ensure sender has enough tokens.
    modifier costs( uint value ) {
        if( _t.balanceOf(address(this)) >= value ) {
            _
        }
    }
    // Ensure specified address has enough tokens.
    modifier costs( address who, uint value ) {
        if( _t.balanceOf(address(who)) >= value ) {
            if( _t.allowance(who, value) >= value ) {
                _
            }
        }
    }
    // Charge sender and proceed on success.
    modifier charges( uint value ) {
        if( charge( value ) )
            _
        }
    }
    // Charge specified address and proceed on success.
    modifier charges( address from, uint value ) {
        if( charge( from, value ) ) {
            _
        }
    }
    // Transfer from sender to self.
    function charge( uint value ) internal returns (bool) {
        return _t.transferFrom( msg.sender, address(this), value );
    }
    // Transfer from specified address to self.
    function charge( address from, uint value ) internal returns (bool) {
        return _t.transferFrom( from, address(this), value );
    }
}
contract DSTokenSystemUser {
    DSTokenSystem _ts;
    function DSTokenSystemUser( DSTokenSystem ts ) {
        _ts = ts;
    }
}
