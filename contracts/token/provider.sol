import 'token/token.sol';

contract DSTokenProvider {
    function getToken(bytes32 symbol) returns (DSToken);
    function tryGetToken(bytes32 symbol) returns (DSToken, bool ok);
}

