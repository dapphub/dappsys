// A mock token registry which has a test token called DAI
// and a special ETH token (see `token/eth_wrapper.sol`)

import 'token/registry.sol';
import 'token/base.sol';
import 'token/eth_wrapper.sol';

contract DSMockTokenRegistry is DSTokenRegistry {
    function DSMockTokenRegistry() {
        var dai = new DSTokenBase(100 * 10**18);
        dai.transfer(msg.sender, 100 * 10**18);
        var eth = new EthToken();
        set("DAI", bytes32(address(dai)));
        set("ETH", bytes32(address(eth)));
    }
}
