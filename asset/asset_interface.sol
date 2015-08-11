contract DSAssetAcceptorInterface {
    function request_deposit(address who, uint amount, bytes32 memo) returns (bool accept) {
        return true;
    }
    function process_deposit( address to, uint amount, bytes32 memo);
}

contract DSAssetInterface {
    function balances( address who ) returns (uint amount);
    function burn( uint amount ) returns (bool success);

    // basic transfer patterns
    function transfer( address to, uint amount ) returns (bool success);
    
    // deposit pattern
    function deposit_to(address to, uint amount, bytes32 memo) returns (bool success);

    // charge pattern
/*
    function withdraw_to_trx( uint amount ) returns (bool success);
    function charge_from_trx( uint amount ) returns (bool success);
    function trx_balance() returns (uint amount);
*/

    // hierarchal delegation pattern
    // function allow_spending( address who, uint max ) returns (bool success);
    // function spend_from( address who, uint amount ) returns (bool success);

    // miner fees
//    function pay_miner( uint fee_amount );
//    function transfer( address to, uint amount, uint miner_fee )
}
