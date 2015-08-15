///  TODO for now you can only do the manual/cumbersome "_ds_proxy_act"
//   for the rest to work there needs to be a serpent contract which:
//       1) discards first 4 bytes of calldata
//       2) interprets next ?? bytes as target address
//       4) interprets next 
//       3) returns byte[BUFSIZE]
import 'dappsys/control/protected.sol';
import 'dappsys/lang/sig_helper.sol';
import 'dappsys/test/debug.sol';

contract UintProvider{
    function magic() returns (uint);
}

contract DSProxyActor is DSProtected
                       , DSSigHelperMixin
{
    // The point of this contract is to avoid needing to use this
    // function:
    function _ds_proxy_act( address target, bytes4 sig, bytes calldata )
             returns (bool solidity_ok) 
    {
        return target.call( sig, calldata);
    }

    address _ds_call_target;
    byte[4096] result;
    function _ds_set_call_target( address target )
             auth()
             returns (bool)
    {
        _ds_call_target = target;
        return true;
    }

    function() {
        var sig = dyn_sig();
        logs("proxy actor fallback");
        //log_named_bytes4("sig:", sig);
        var ok = _ds_call_target.call( msg.data );
        log_named_uint( "real magic", UintProvider(_ds_call_target).magic());
        log_bool(ok);
    }
    // TODO you can't actually do this.
    /*
    function() returns (byte[4096]) {
        if( authed() ) {
            var returner = ByteReturnerInterface(_ds_call_target);
            _ds_call_target.call(msg.data);
        }
    }
    */
}


// Force solidity to do things it doesn't want
contract ByteReturnerInterface {
    function getReturnValue(address target, bytes calldata)
             returns (byte[4096]);
}


