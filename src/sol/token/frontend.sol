// Static proxy for Tokens. Allows you to give a single address to
// UI devs, but requires your dapp to manage controller updates
// at the contract level.
import 'auth/auth.sol';
import 'token/controller.sol';
import 'token/event_callback.sol';
import 'token/token.sol';

contract DSTokenFrontend is DSToken
                          , DSTokenEventCallback
                          , DSAuth
{
    DSTokenController _controller;
    function DSTokenFrontend( DSTokenController controller ) {
        setController( controller );
    }
    function setController( DSTokenController controller )
             auth()
             returns (bool)
    {
        _controller = controller;
        return true;
    }
    function getController() constant returns (DSTokenController controller) {
        return _controller;
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
        return _controller.totalSupply();
    }
    function balanceOf( address who ) constant returns (uint value) {
        return _controller.balanceOf( who );
    }
    function allowance(address owner, address spender) constant returns (uint _allowance) {
        return _controller.allowance( owner, spender );
    }

    // ERC20Stateful
    function transfer( address to, uint value) returns (bool ok) {
        return _controller.transfer( msg.sender, to, value );
    }
    function transferFrom( address from, address to, uint value) returns (bool ok) {
        return _controller.transferFrom( msg.sender, from, to, value );
    }
    function approve(address spender, uint value) returns (bool ok) {
        return _controller.approve( msg.sender, spender, value );
    }
}

