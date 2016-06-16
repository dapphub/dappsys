// A Vault is your system's token holder.
import 'auth.sol';
import 'token/erc20.sol';


contract DSTokenVault is DSAuth {
    function transfer(ERC20 token, address to, uint amount)
        auth
        returns (bool)
    {
        return token.transfer(to, amount);
    }
    function transferFrom(ERC20 token, address from, address to, uint amount)
        auth
        returns (bool)
    {
        return token.transferFrom(from, to, amount);
    }
}
