// Static proxy for Tokens. Allows you to give a single address to
// UI devs, but requires your dapp to manage updates at the contract level.
import 'token/erc20.sol';

contract DSTokenProxy is ERC20 {
    ERC20 implementation;
}

contract DSTokenProxyAcceptor is ERC20 {
    function transfer( address caller, address to, uint value) returns (bool ok);
    function transferFrom( address caller, address from, address to, uint value) returns (bool ok);
    function approve( address caller, address spender, uint value) returns (bool ok);
    function unapprove( address caller, address spender) returns (bool ok);
}

