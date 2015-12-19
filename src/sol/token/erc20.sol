// Token standard API
// https://github.com/ethereum/EIPs/issues/20
contract ERC20 {
    function totalSupply() constant returns (uint supply);
    function balanceOf( address who ) constant returns (uint value);
    function transfer( address to, uint value) returns (bool ok);
    function transferFrom( address from, address to, uint value) returns (bool ok);
    function approve(address spender, uint value) returns (bool ok);
    function unapprove(address spender) returns (bool ok);
    function allowance(address owner, address spender) constant returns (uint _allowance);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approved( address indexed owner, address indexed spender, uint value);
    event Unapproved( address indexed owner, address indexed spender );
}


