import 'dappsys/protected.sol';

contract DSBalanceDB is DSProtected {
    uint                       public    supply;
    mapping( address => uint ) public    balances;

    function add_balance( address to, uint amount ) auth() returns (bool success) {
        if( supply + amount < supply ) {
            return false;
        }
        balances[to] += amount;
        supply += amount;
        return true;
    }
    function sub_balance( address from, uint amount ) auth() returns (bool success) {
        if( balances[from] - amount > balances[from] ) { // underflow
            return false;
        }
        balances[from] -= amount;
        supply -= amount;
        return true;
    }
}
