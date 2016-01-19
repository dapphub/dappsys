import 'data/map.sol';
import 'token/provider.sol';

// Simple registry implementing DSTokenProvider
contract DSTokenRegistry is DSTokenProvider, DSMap {
    function getToken(bytes32 symbol) returns (DSToken) {
        return DSToken(address(get(symbol)));
    }
}

