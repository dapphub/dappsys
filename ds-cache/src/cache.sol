// store.sol -- authed nullable key-value store with expirations

// Copyright 2016-2017  Nexus Development, LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// A copy of the License may be obtained at the following URL:
//
//    https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

pragma solidity ^0.4.9;

import 'ds-auth/auth.sol';

contract DSICache is DSIStore {
    function set(bytes32 key, bytes32 value, uint expiry);
    function tryGet( bytes32 key ) constant returns (bytes32 value, uint expiry);
}

contract DSCacheEvents {
    event LogCacheChange( bytes32 indexed key, bytes32 indexed value, uint expiration );
}


contract DSCache is DSICache
                  , DSCacheEvents
                  , DSAuth
{
    struct ExpiringNullableValue {
        bytes32 _value;
        uint    _expiry; // TODO does uint256(-1) work?
    }
    mapping( bytes32 => NullableValue ) _storage;

    function set(bytes32 key, bytes32 value )
             auth
    {
        _storage[key] = ExpiringNullableValue(value, uint(-1));
        LogStoreChange( key, value, uint(-1) );
    }
    function unset(bytes32 key)
             auth
    {
        _storage[key] = ExpiringNullableValue(0x0, 0);
        LogStoreChange( key, 0x0, 0 );
    }

    function has(bytes32 key)
             constant
             returns (bool)
    {
        return _storage[key]._expiry >= now;
    }

    // Throws.
    function get( bytes32 key )
             constant
             returns (bytes32 value)
    {
        var (val, expiry) = tryGet(key);
        if( expiry < now ) throw;
        return val;
    }

    function tryGet( bytes32 key ) constant returns (bytes32 value, uint expiry ) {
        var nvalue = _storage[key];
        return (nvalue._value, nvalue._expiry);
    }

}
