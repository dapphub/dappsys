import 'token/erc20.sol';
import 'token/frontend.sol';
import 'controller.sol'; // tmp FrontendBAse

contract DSTokenFrontend2 is ERC20
                           , DSFrontendBase
{
    function DSTokenFrontend2( DSController controller )
             DSFrontendBase( controller )
    {}
    function totalSupply() constant returns (uint supply) { 
        pushContext();
        ERC20(_controller).totalSupply();
        return uint(popContext());
    }
    function transfer( address to, uint value) returns (bool ok) {
        pushContext();
        ERC20(_controller).transfer(to, value);
        // return popContext();    can't do this...
        if( popContext() == 0x0) {
            return false;
        } else {
            return true;
        }
    }
    function emitTransfer( address from, address to, uint value )
        auth
    {
        Transfer(from, to, value);
    }
}

contract DSTokenFrontendShim is DSAuth
{
    DSController _controller;
    DSTokenFrontend _old_frontend;
    function transfer( address _sender, address to, uint value )
        auth
        returns (bool)
    {
        // TODO manually adjust the context before and after
        DSToken(_controller).transfer(to, value);
    }
}
