import 'token/erc20.sol';
import 'auth/auth.sol';

contract DSToken is ERC20 {}

// TODO: possibly use enums. Issues with defining enums in subpackages.
// 0 == transfer
// 1 == approval
contract DSTokenEventCallback {
    function eventCallback(uint8 event_type, address arg1, address arg2, uint amount) returns (bool);
}
contract DSTokenControllerType is ERC20Stateless, ERC20Events {
    // ERC20Stateful proxies
    function transfer( address caller, address to, uint value) returns (bool ok);
    function transferFrom( address caller, address from, address to, uint value) returns (bool ok);
    function approve( address caller, address spender, uint value) returns (bool ok);
    
    function getProxy() constant returns (DSTokenFrontend);
    function setProxy( DSTokenFrontend proxy ) returns (bool);
    function getDBs() constant returns (DSBalanceDB, DSApprovalDB);
    function updateDBs( DSBalanceDB new_bal_db, address new_bal_auth, bool new_bal_auth_mode
                      , DSApprovalDB new_appr_db, address new_appr_auth, bool new_appr_auth_mode )
             returns (bool);

}
