// Attach to your balance DB to have a way for system contracts to print/burn
// tokens for themselves.

import 'auth.sol';
import 'data/balance_db.sol';

contract DSTokenSupplyManager is DSAuth
{
    DSBalanceDB _db;
    function DSTokenSupplyManager( DSBalanceDB db )
    {
        setBalanceDB(db);
    }
    function setBalanceDB( DSBalanceDB db )
        auth
    {
        _db = db;
    }
    function demand(uint amount)
        auth
    {
        _db.addBalance(msg.sender, amount);
    }
    // unsafe! protect with auth!
    // see "token/burner::DSTokenBurner" for user-friendly version
    function destroy(uint amount)
        auth
    {
        _db.subBalance(msg.sender, amount);
    }
}

