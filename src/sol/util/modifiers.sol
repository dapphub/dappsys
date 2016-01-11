contract DSModifiers {
    mapping(bytes4=>bool) _executed_functions;
    modifier only_once() {
        if( !_executed_functions[msg.sig] ) {
            _executed_functions[msg.sig] = true;
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
    modifier keys_only() {
        if ( msg.sender == tx.origin ) {
            _
        }
    }
    modifier contracts_only() {
        if( msg.sender != tx.origin ) {
            _
        } 
    }
    modifier static_auth( address auth ) {
        if( msg.sender == auth ) {
            _
        }
    }
 
}
