import "asset/baldb/balance_db.sol";
import "interfaces.sol";
import "dappsys/util/math.sol";

contract MakerInterestBearingBalanceDB 
      is DSBalanceDB
       , DSFixedPointMathUser(0)
{
    uint                        last_update;
    mapping( uint => uint )     accumulator; // timestamp to accumulator value

    mapping( address => uint )  bals;
    mapping( address => uint )  last_poked;
    uint  _supply;
    uint  _supply_last_poked;

    MakerFeedProvider           feeds;

    function scale_balance( address who ) {
        var old_acc = accumulator[last_poked[who]];
        var new_acc = accumulator[now];
        var old_bal = bals[who];
        var new_bal = mul(old_bal, div(new_acc, old_acc));
        bals[who] = new_bal;
        last_poked[who] = now;
    }
    function add_balance( address who, uint amount ) returns (bool success) {
        // TODO how to handle overflow? Things will go wrong if we are close to overflowing anyway...
        poke();
        scale_balance( who );
        bals[who] += amount;
        _supply += amount;
        return true;
    }
    function sub_balance( address who, uint amount ) returns (bool success) {
        poke();
        scale_balance( who );
        if( bals[who] > amount ) {
            bals[who] -= amount;
            _supply -= amount;
            return true;
        }
        return false;
    }
    function balances( address who ) returns (uint amount) {
        poke();
        scale_balance( who );
        return bals[who];
    }
    function supply() returns (uint) {
        poke();
        var old_acc = accumulator[_supply_last_poked];
        var new_acc = accumulator[now];
        _supply = mul(_supply, div(new_acc, old_acc));
        _supply_last_poked = now;
        return _supply;
    }

    function poke() {
        var last_acc = accumulator[last_update];
        var duration = now - last_update;
        var rate = feeds.get( "DAI_RATE" );
        var new_acc = last_acc * pow((10**21) + uint(rate), duration);
        accumulator[now] = new_acc;
        last_update = now;
    }
}
