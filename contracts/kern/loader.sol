import 'dappsys/control/auth.sol';
import 'dappsys/lang/get.sol';

contract DSLoader is DSAuth
                   , DSAddressGetter
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
    function get() returns (address) {
        return implementation;        
    }
    function() returns (address) {
        return implementation;
    }
}
