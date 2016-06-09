import 'auth.sol';
import 'data/nullmap.sol';

contract DSComponent is DSAuth {
    DSNullMap _env;
    
    function DSComponent(DSNullMap env) {
        updateEnvironment(env);
    }
    function updateEnvironment(DSNullMap env)
        auth
    {
        _env = env;
//        refreshEnvironment();    TODO think again about this later
    }
    // Save references to local storage.
    // System updates will call this.
    function refreshEnvironment();
}
