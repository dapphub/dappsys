import 'control/auth.sol';
import 'lang/get.sol';

contract DSLoader is DSAuth
    //               , DSAddressGetter
{
    address public implementation;
    bool    public finalized;
    function _ds_set_impl( address impl )
             auth()
    {
        implementation = impl;
    }
    function _ds_finalize()
             auth()
    {
        finalized = true;
    }
    function() returns (address) {
        return implementation;
    }
}


contract DSLoaderUser {
    DSLoader _loader;
    function DSLoaderUser( DSLoader loader ) {
        _loader = loader;
    }
    modifier sync() {
        
    }
}
