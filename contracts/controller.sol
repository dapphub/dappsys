import 'auth.sol';
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
        _controller._ds_pushContext();
    }
    function popContext() internal returns (bytes32) {
        return _controller._ds_popContext();
    }
}

// Generic controller
// Typed actions forwarded from approved `frontends`.

contract DSController is DSAuth, DSNullMap {
    // `_storage` on DSNullMap is the "environment" for the actions
    // use auth infrastructure to connect frontends
    struct ActionSequence {
        bool is_defined;
        DSControlledAction[] steps;
    }
    mapping( bytes4 => ActionSequence ) _scripts;

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
    function _ds_pushContext()
        auth
    {
        _stack.push(Context(msg.sender, 0x0));
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
        // auth  ?
    {
        if( !isAuthorized() ) {
            throw;
        }
        
        var script = _scripts[msg.sig];
        var steps = script.steps;
        for( var i = 0; i < steps.length; i++ ) {
            
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
