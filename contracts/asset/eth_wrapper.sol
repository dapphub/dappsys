contract EthManagerBase {
    function withdraw_eth(uint amount) returns (bool ok);
    // Process the deposit
    function() returns (bool) {
        return false;
    }
}

contract EthManager0 is DSAsset0 {}
contract EthManager0Impl is DSAsset0Impl {
    // TODO double-check .call() semantics to ensure balance is always right
    function withdraw_eth( uint amount ) returns (bool ok) {
        ok = db.sub_balance( msg.sender, amount );
        if( ok ) {
            msg.sender.call.value(amount)();
        }
        return ok;
    }
    function() returns (bool) {
        return db.add_balance( msg.sender, msg.value );
    }
}
