import 'auth.sol';
import 'data/nullmap.sol';

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

    address sender;
    bytes32 returned;

    function setReturn(bytes32 value)
        auth
    {
    }
    function()
        auth
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

// Override this and add the *sender-extended* function type this action handles.
// Use `auth` to restrict access to only *controllers*.
//    TODO also time-extended signature? all context? store context elsewhere in global singleton??
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
