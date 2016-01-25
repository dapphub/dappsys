contract DSModifiers {
    mapping(bytes4=>bool) __executed_functions;
    modifier only_once() {
        if( !__executed_functions[msg.sig] ) {
            __executed_functions[msg.sig] = true;
            _
        }
    }
    modifier only_if( bool what ) {
        if( what ) {
            _
        }
    }
    modifier self_only() {
        if( msg.sender == address(this) ) {
            _
        }
    }
    modifier simple_static_auth( address auth ) {
        if( msg.sender == auth ) {
            _
        }
    }
}
