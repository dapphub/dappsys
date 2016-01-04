// A base contract for single-contract tokens. All the data is held in 
// the storage locally and there are no extra functions (initial issuance
// is done via constructor argument).
// Contracts that plan to ever export data should be using `token/controller.sol`.
import 'token/erc20.sol';

contract DSTokenBase is ERC20 {
    mapping( address => uint ) _balances;
    mapping( address => mapping( address => uint ) ) _approvals;
    uint _supply;
    function DSTokenBase( uint initial_balance ) {
        _balances[msg.sender] = initial_balance;
        _supply = initial_balance;
    }
    function totalSupply() constant returns (uint supply) {
        return _supply;
    }
    function balanceOf( address who ) constant returns (uint value) {
        return _balances[who];
    }
    function transfer( address to, uint value) returns (bool ok) {
        var from = msg.sender;
        if( _balances[from] >= value ) {
            _balances[from] -= value;
            _balances[to] += value;
            Transfer( from, to, value );
            return true;
        }
    }
    function transferFrom( address from, address to, uint value) returns (bool ok) {
        if( _approvals[from][msg.sender] >= value ) {
            _approvals[from][msg.sender] -= value;
            _balances[from] -= value;
            _balances[to] -= value;
            Transfer( from, to, value );
            return true;
        }
    }
    function approve(address spender, uint value) returns (bool ok) {
        _approvals[msg.sender][spender] = value;
        Approval( msg.sender, spender, value );
        return true;
    }
    function allowance(address owner, address spender) constant returns (uint _allowance) {
        return _approvals[owner][spender];
    }
}
