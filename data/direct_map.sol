// A direct map makes use of the entire storage space directly. This prevents
// you from using any other storage variables. This should cause a compile
// error if you add more local variables in a derived type.
// Authorization is still possible by putting constant addresses in code.
contract DSDirectMap { //is DSStaticAuth {
    bytes32[2**256] _storage;
    function _ds_set( bytes32 key, bytes32 val )
//             static_auth( @CONSTANT( "" ) )      <-- attach to derived classes
             internal {
        _storage[uint(key)] = val;
    }
    function _ds_get( bytes32 key ) internal returns (bytes32 val) {
        return _storage[uint(key)];
    }
}
