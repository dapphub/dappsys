// Token interface from here:  https://github.com/ethereum/EIPs/issues/20

contract StandardToken {
    function decimals() constant returns (uint256 decimals);
    function totalSupply() constant returns (uint256 supply);
    function balanceOf(address _address) constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) returns (bool _success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function unapprove(address _spender) returns (bool success);
    function allowance(address _address, address _spender) constant returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _address, address indexed _spender, uin256 _value);
}

contract DSToken0 is StandardToken {
    function transferWithMemo( address to, uint amount, bytes32 memo );
    function _ds_swap_bal_db( DSBalanceDB new_balances, DSAuthority new_balances_auth, uint8 bal_auth_mode
             returns (bool ok);
    function _ds_swap_appr_db( DSApprovalDB new_approvals, DSAuthority new_approval_auth, uint8 approval_auth_mode )
             returns (bool ok);
}
