contract DepthChecker {
    function check_depth(uint16 depth) external returns (bool) {
        if( depth == 1 || depth == 0 ) {
            return true;
        }
        return this.check_depth(depth-1);
    }
    modifier requires_depth( uint16 depth ) {
        if( this.check_depth(depth) ) {
            _
        }
    }

}
