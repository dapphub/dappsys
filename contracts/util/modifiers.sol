contract DSModifiers {
    modifier only_if( bool what ) {
        if( what ) {
            _
        }
    }
    modifier keys_only() {
        if ( msg.sender == tx.origin ) {
            _
        }
    }
    modifier contracts_only( ) {
        if( msg.sender != tx.origin ) {
            _
        } 
    }
}
