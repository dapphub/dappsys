// Token standard API
// https://github.com/ethereum/EIPs/issues/20
contract ERC20 {
    function totalSupply() constant returns (uint supply);
//    function totalSupply() constant returns (uint supply, bool ok);
    function balanceOf( address who ) constant returns (uint amount);
 //   function balanceOf( address who ) constant returns (uint amount, bool ok);
    function transfer( address to, uint amount) returns (bool ok);
    function transferFrom( address from, address to, uint value) returns (bool ok);
    function approve(address spender, uint value) returns (bool ok);
    function unapprove(address spender) returns (bool ok);
    function allowance(address owner, address spender) constant returns (uint _allowance);
//    function allowance(address owner, address spender) constant returns (uint _allowance, bool ok);
    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval( address indexed owner, address indexed spender, uint value);
}


