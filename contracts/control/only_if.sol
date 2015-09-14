
contract OnlyIfMixin {
    modifier only_if( bool what ) {
        if( what ) {
            _
        }
    }
}
