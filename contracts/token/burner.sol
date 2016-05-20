import 'token/token.sol';

import 'token/supply_manager.sol';

contract DSTokenBurner
{
    DSToken _token;
    DSTokenSupplyController _supply_controller;
    function DSTokenBurner(DSToken token, DSTokenSupplyController supply_controller) {
        _token = token;
        _supply_controller = supply_controller;
    }
    function burn(uint amount) {
        _token.transferFrom(msg.sender, this, amount);
        _supply_controller.destroy(amount);
    }
}
