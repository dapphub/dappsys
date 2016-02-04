import 'token/token.sol';
import 'token/provider.sol';

contract DSTokenProviderUser {
    DSTokenProvider _tokens;
    function DSTokenProviderUser( DSTokenProvider tokens ) {
        _tokens = tokens;
    }

    function getToken( bytes32 symbol ) internal returns (DSToken token) {
        token = _tokens.getToken( symbol );
        // TODO is this re-throw just in case needed ?
        if( address(token) == address(0x0) ) {
            throw;
        }
        return token;
    }

    function totalSupply( bytes32 symbol ) internal returns (uint supply) {
        return getToken(symbol).totalSupply();
    }
    function balanceOf( address who, bytes32 symbol ) internal returns (uint value) {
        return getToken(symbol).balanceOf(who);
    }
    function allowance(address owner, address spender, bytes32 symbol) internal returns (uint allowance) {
        return getToken(symbol).allowance(owner, spender);
    }

    function transfer( address to, uint value, bytes32 symbol ) internal returns (bool ok) {
        return getToken(symbol).transfer(to, value);
    }
    function transferFrom( address from, address to, uint value, bytes32 symbol) internal returns (bool ok) {
        return getToken(symbol).transferFrom(from,to, value);
    }
    function approve(address spender, uint value, bytes32 symbol) internal returns (bool ok) {
        return getToken(symbol).approve(spender, value);
    }

}

