contract DSFixedPointMathUser {
    uint _precision;
    function DSFixedPointMathUser( uint precision ) {
        if( precision == 0 ) {
            _precision = 10 ** 18;
        }
        _precision = precision;
    }
    function unit( uint a ) internal returns (uint c) {
        return a * _precision;
    }
    function mul(uint a, uint b) internal returns (uint c) {
        return (a * b) / _precision;
    }
    function div(uint a, uint b) internal returns (uint c) {
        return a / (b * _precision);
    }
    function pow(uint a, uint b) internal returns (uint c) {
        return 0x4444;
    }
    function max( uint a, uint b ) internal returns ( uint c ) {
        if( a > b) {
            return a;
        }
        return b;
    }
    function min( uint a, uint b ) internal returns ( uint c ) {
        if( a < b) {
            return a;
        }
        return b;
    }
}
