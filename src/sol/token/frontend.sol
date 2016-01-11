// Static proxy for Tokens. Allows you to give a single address to
// UI devs, but requires your dapp to manage implementation updates
//  at the contract level.
import 'token/token.sol';

contract DSTokenFrontend is DSToken
                          , DSTokenEventCallback
                          , DSAuth
{
    DSTokenController _impl;
    function DSTokenFrontend( DSTokenController impl ) {
        setImpl( impl );
    }
    function setImpl( DSTokenController impl )
             auth()
             returns (bool)
    {
        _impl = impl;
        return true;
    }

    // ERCEvents
    function eventCallback( uint8 event_type, address arg1, address arg2, uint amount )
             auth()
             returns (bool)
    {
        if( event_type == 0 ) {
            Transfer( arg1, arg2, amount );
        } else if ( event_type == 1 ) {
            Approval( arg1, arg2, amount );
        } else {
            return false;
        }
        return true;
    }

    // ERC20Stateless
    function totalSupply() constant returns (uint supply) {
        return _impl.totalSupply();
    }
    function balanceOf( address who ) constant returns (uint value) {
        return _impl.balanceOf( who );
    }
    function allowance(address owner, address spender) constant returns (uint _allowance) {
        return _impl.allowance( owner, spender );
    }

    // ERC20Stateful
    function transfer( address to, uint value) returns (bool ok) {
        return _impl.transfer( msg.sender, to, value );
    }
    function transferFrom( address from, address to, uint value) returns (bool ok) {
        return _impl.transferFrom( msg.sender, from, to, value );
    }
    function approve(address spender, uint value) returns (bool ok) {
        return _impl.approve( msg.sender, spender, value );
    }
}

