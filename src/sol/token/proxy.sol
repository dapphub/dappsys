// Static proxy for Tokens. Allows you to give a single address to
// UI devs, but requires your dapp to manage updates at the contract level.
import 'token/erc20.sol';

// The controller implementation must adhere to this interface
contract DSTokenProxyTarget is ERC20 {
    function transfer( address caller, address to, uint value) returns (bool ok);
    function transferFrom( address caller, address from, address to, uint value) returns (bool ok);
    function approve( address caller, address spender, uint value) returns (bool ok);
}

// We need this interface to avoid circular dependencies. The controller only needs to
// know about this function.
contract DSTokenProxyEventLogger {
    function eventCallback(uint8 event_type, address arg1, address arg2, uint amount) returns (bool);
}

contract DSTokenProxy is ERC20
                       , DSTokenProxyEventLogger
                       , DSAuth
{
    DSTokenProxyTarget _impl;
    function DSTokenProxy( DSTokenProxyTarget impl ) {
        setImpl( impl );
    }
    function setImpl( DSTokenProxyTarget impl )
             auth()
             returns (bool)
    {
        _impl = impl;
        return true;
    }
    // 0 == transfer
    // 1 == approval
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
    function totalSupply() constant returns (uint supply) {
        return _impl.totalSupply();
    }
    function balanceOf( address who ) constant returns (uint value) {
        return _impl.balanceOf( who );
    }
    function transfer( address to, uint value) returns (bool ok) {
        return _impl.transfer( msg.sender, to, value );
    }
    function transferFrom( address from, address to, uint value) returns (bool ok) {
        return _impl.transferFrom( msg.sender, from, to, value );
    }
    function approve(address spender, uint value) returns (bool ok) {
        return _impl.approve( msg.sender, spender, value );
    }
    function allowance(address owner, address spender) constant returns (uint _allowance) {
        return _impl.allowance( owner, spender );
    }
}

