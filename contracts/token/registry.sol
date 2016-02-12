import 'data/nullmap.sol';
import 'token/provider.sol';

// Simple registry implementing DSTokenProvider
contract DSTokenRegistry is DSTokenProvider, DSNullMap {
    function getToken(bytes32 symbol) returns (DSToken) {
        return DSToken(address(get(symbol)));
    }
}

