// This is some scratch work for a an upgradeable "frontend" contract which is safe/useful on reentry

import 'auth.sol';
import 'util/fallback_failer.sol';
import 'actor/base.sol';
import 'data/nullmap.sol';

// Generic controller
// TODO generic events
contract DSController is DSAuth, DSBaseActor {
    mapping( bytes32 => bytes32 ) _env;

    // Auth Group: actions
    function _ds_getEnv(bytes32 key) returns (bytes32 value)
    {
        return _env[key];
    }
    function _ds_setEnv(bytes32 key, bytes32 value)
        auth
    {
        _env[key] = value;
    }
    function _ds_getSender() returns (address sender) {
        return _stack[_stack.length-1].sender;
    }
    function _ds_setReturn(bytes32 value)
        auth
    {
        _stack[_stack.length-1].returned = value;
    }
    // end action callbacks

    
// Auth group: admins
    struct Action {
        DSAction target;
        uint value;
        bytes calldata;
        bool must_succeed;
    }
    mapping( bytes4 => Action[] ) _scripts;

    // A pair of hacks to enable configuring scripts while solidity is still limiting
    function _ds_resetScript(bytes4 sig)
        auth
    {
        delete _scripts[sig];
    }
    function _ds_pushAction(bytes4 sig, DSAction target, uint value, bytes calldata, bool must_succeed)
        auth
    {
        var a = Action(target, value, calldata, must_succeed);
        _scripts[sig].push(a);
    }
    // end admin functions


    // The fun parts
    Context[] _stack;
    struct Context {
        address sender;
        bytes32 returned;
    }
    function pushContext()
        internal
    {
        _stack.push(Context(msg.sender, 0x0));
    }
    function popContext()
        internal
        returns (bytes32)
    {
        var ctx = _stack[_stack.length-1];
        _stack.length--; // TODO I think this deletes the item?
        return ctx.returned;
    }
    function()
        auth
        returns (bytes32)
    {
        pushContext();
        var script = _scripts[msg.sig];
        for( var i = 0; i < script.length; i++ ) {
            var a = script[i];
            var success = a.target.call.value(a.value)(a.calldata);
            if( !success && a.must_succeed ) {
                throw;
            }
        }
        return popContext();
    }
}

// Override this and add the function type this action handles.
// Pass returns to the controller via `setReturn`.
//  e.g.  transfer(address,uint);
contract DSAction is DSAuth, DSFallbackFailer
{
    DSController _controller;
    function DSControlledAction( DSController environment )
    { updateController(_controller); }
    function updateController( DSController controller )
        auth
    { _controller = controller; }

    function setReturn(bytes32 value)
        internal
    { DSController(_controller)._ds_setReturn(value); }

    function setReturn(bool value)
        internal
    { if (value) { setReturn(0x1); } else { setReturn(0x0); } }

    function getSender()
        internal
    { DSController(_controller)._ds_getSender(); }

    function getEnv(bytes32 key)
        internal
        returns (bytes32)
    { DSController(_controller)._ds_getEnv(key); }

    modifier action() {
        if( msg.sender != address(_controller) ) {
            throw;
        }
    }
}
