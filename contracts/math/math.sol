contract DSFixedPointMathMixin {
    uint _precision;
    function DSFixedPointMathMixin( uint precision ) {
        _precision = precision;
    }
    function _fxp_unit( uint a ) internal returns (uint c) {
        return a * _precision;
    }
    function _fxp_mul(uint a, uint b) internal returns (uint c) {
        return (a * b) / _precision;
    }
    function _fxp_div(uint a, uint b) internal returns (uint c) {
        return (a / b) * _precision;
    }
    function _fxp_pow(uint a, uint b) internal returns (uint c) {
        return 0x4444;
    }
    function _fxp_max( uint a, uint b ) internal returns ( uint c ) {
        if( a > b) {
            return a;
        }
        return b;
    }
    function _fxp_min( uint a, uint b ) internal returns ( uint c ) {
        if( a < b) {
            return a;
        }
        return b;
    }
}

// Don't re-deploy use the factory to get singleton instances for each precision
contract DSFixedPointMath is DSFixedPointMathMixin {
    function DSFixedPointMath( uint precision )
             DSFixedPointMathMixin( precision)
    {}

    function fxp_unit( uint a ) returns (uint c) {
        return _fxp_unit(a);
    }
    function fxp_mul(uint a, uint b) returns (uint c) {
        return _fxp_mul(a, b);
    }
    function fxp_div(uint a, uint b) returns (uint c) {
        return _fxp_div(a, b);
    }
    function fxp_pow(uint a, uint b) returns (uint c) {
        return _fxp_pow(a, b);
    }
    function fxp_max( uint a, uint b ) returns ( uint c ) {
        return _fxp_max(a, b);
    }
    function fxp_min( uint a, uint b ) returns ( uint c ) {
        return _fxp_min(a, b);
    }
}

// deployed at:
contract DSFixedPointMathFactory {
    mapping( uint => DSFixedPointMath ) _fxps; // TODO optimized array
    function fxp(uint precision) returns (DSFixedPointMath) {
        if( _fxps[precision] == DSFixedPointMath(0x0) ) {
            _fxps[precision] = new DSFixedPointMath(precision);
        }
        return _fxps[precision];
    }
}

contract DSFixedPointMathFactoryUser {
    address fxp_math_factory = 0x0;
}

contract DSFixedPointMathUser is DSFixedPointMathFactoryUser
{
    DSFixedPointMath fxp_math;
    function DSFixedPointMathUser( uint precision ) {
        if( precision == 0 ) {
            precision = 10 ** 18;
        }
        fxp_math = DSFixedPointMathFactory(fxp_math_factory).fxp(precision);
    }
}
