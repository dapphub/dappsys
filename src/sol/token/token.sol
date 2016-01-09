import 'token/erc20.sol';
import 'auth/auth.sol';

contract DSToken is ERC20 {}

// TODO: possibly use enums. Issues with defining enums in subpackages.
// 0 == transfer
// 1 == approval
contract DSTokenEventCallback {
    function eventCallback(uint8 event_type, address arg1, address arg2, uint amount) returns (bool);
}
contract DSTokenController is ERC20Stateless, ERC20Events {
    function transfer( address caller, address to, uint value) returns (bool ok);
    function transferFrom( address caller, address from, address to, uint value) returns (bool ok);
    function approve( address caller, address spender, uint value) returns (bool ok);
}
contract DSTokenFrontend is ERC20, DSTokenEventCallback {}
