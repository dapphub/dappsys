import 'token/base.sol';

contract EthToken is DSTokenBase(0) {
    event Deposited( address indexed who, uint amount );
    event Withdrew( address indexed who, uint amount );
    function withdraw( uint amount ) returns (bool ok) {
        if( _balances[msg.sender] > amount ) {
            _balances[msg.sender] -= amount;
            if( msg.sender.send( amount ) ) {
                Withdrew( msg.sender, amount );
                return true;
            }
        }
    }
    function deposit( uint amount ) returns (bool ok ) {
        if( msg.value != amount )
            return false;
        _balances[msg.sender] += amount;
        _supply += amount;
        Deposited( msg.sender, amount );
        return true;
    }
    function() returns (bool) {
        return deposit( msg.value );
    }
}
