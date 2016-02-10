import 'token/base.sol';

contract DSEthTokenEvents {
    event Deposit( address indexed who, uint amount );
    event Withdrawal( address indexed who, uint amount );
}

contract DSEthToken is DSTokenBase(0), DSEthTokenEvents {
    function totalSupply() constant returns (uint supply) {
        return this.balance;
    }
    function withdraw( uint amount ) returns (bool ok) {
        if( _balances[msg.sender] >= amount ) {
            if( msg.sender.call.value( amount )() ) {
                _balances[msg.sender] -= amount;
                Withdrawal( msg.sender, amount );
                return true;
            }
        }
    }
    function deposit() returns (bool ok) {
        _balances[msg.sender] += msg.value;
        Deposit( msg.sender, msg.value );
        return true;
    }
    function() returns (bool) {
        return deposit();
    }
}
