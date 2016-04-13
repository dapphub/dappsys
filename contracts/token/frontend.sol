// Static proxy for Tokens. Allows you to give a single address to
// UI devs, but requires your dapp to manage controller updates
// at the contract level.
import 'auth.sol';
import 'token/controller.sol';
import 'token/event_callback.sol';
import 'token/token.sol';

contract DSTokenFrontend is DSToken
                          , DSTokenEventCallback
                          , DSAuth
{
    DSTokenController _controller;
    function setController( DSTokenController controller )
             auth()
    {
        _controller = controller;
    }
    function getController() constant returns (DSTokenController controller) {
        return _controller;
    }

    // ERCEvents
    function emitTransfer( address from, address to, uint amount )
             auth()
    {
        Transfer( from, to, amount );
    }
    function emitApproval( address holder, address spender, uint amount )
             auth()
    {
        Approval( holder, spender, amount );
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

