import 'auth.sol';
import 'actor/base.sol';
import 'data/nullmap.sol';

contract DSFrontendBase is DSAuth
{
    DSController _controller;
    function DSFrontendBase( DSController controller ) {
        setController(controller);
    }
    function setController( DSController controller ) {
        _controller = controller;
    }
    function pushContext() internal {
        _controller._ds_pushContext(msg.sender);
    }
    function popContext() internal returns (bytes32) {
        return _controller._ds_popContext();
    }
}

// Generic controller
// Typed actions forwarded from approved `frontends`.

contract DSController is DSAuth, DSNullMap, DSBaseActor {
    // `_storage` on DSNullMap is the "environment" for the actions
    // use auth infrastructure to connect frontends
    struct ControlledAction {
        Action action;
        bool must_succeed;
    }
    mapping( bytes4 => ControlledAction[] ) _scripts;

    Context[] _stack;
    struct Context {
        address sender;
        bytes32 returned;
    }

    function _ds_getSender() returns (address sender) {
        return _stack[_stack.length-1].sender;
    }
    function _ds_setReturn(bytes32 value)
        auth
    {
        _stack[_stack.length-1].returned = value;
    }
    function _ds_pushContext(address sender)
        auth
    {
        _stack.push(Context(sender, 0x0));
    }
    function _ds_popContext()
        auth
        returns (bytes32)
    {
        var ctx = _stack[_stack.length-1];
        _stack.length--;
        return ctx.returned;
    }
    function()
        auth
    {
        if( !isAuthorized() ) {
            throw;
        }
        var script = _scripts[msg.sig];
        for( var i = 0; i < script.length; i++ ) {
            var controlled_action = script[i];
            var success = tryExec(controlled_action.action);
            if( !success && controlled_action.must_succeed ) {
                throw;
            }
        }
    }
}

// Override this and add the function type this action handles.
// Pass returns to the controller via `setReturn`.
//  e.g.  transfer(address,uint);
contract DSControlledAction is DSAuth {
    DSNullMap _env;
    function DSControlledAction( DSNullMap environment ) {
        updateEnvironment(environment);
    }
    function updateEnvironment( DSNullMap environment )
        auth
    {
        _env = environment;
    }
}
