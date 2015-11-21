contract DSAddressGraphDB is DSAuth {
    mapping(address=>mapping(address=>mapping(bytes32=>bytes32))) _graph;

    function set( address from, address to, bytes32 key, bytes32 value )
             auth()
             returns (bool ok)
    {
        _graph[from][to][key] = value;
        event_set( from, to, key, value );
        return true;
    }
    event event_set( address indexed from
                   , address indexed to
                   , bytes32 indexed key
                   , bytes32 value );
    function get( address from, address to, bytes32 key )
             constant
             returns (bytes32 value, bool ok)
    {
        return (_graph[from][to][key], true);
    }
}
