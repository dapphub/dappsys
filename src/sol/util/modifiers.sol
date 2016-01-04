contract DSModifiers {
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
