import 'token/base.sol';

contract EthToken is DSTokenBase(0) {
    event Deposit( address indexed who, uint amount );
    event Withdrawal( address indexed who, uint amount );
    function withdraw( uint amount ) returns (bool ok) {
        if( _balances[msg.sender] > amount ) {
            _balances[msg.sender] -= amount;
            if( msg.sender.send( amount ) ) {
                Withdrawal( msg.sender, amount );
                return true;
            }
        }
    }
    function deposit() returns (bool ok) {
        _balances[msg.sender] += msg.value;
        _supply += msg.value;
        Deposit( msg.sender, msg.value );
        return true;
    }
    function() returns (bool) {
        return deposit();
    }
}
