/*
import 'auth.sol';
import 'auth/basic_authority.sol';
import 'lang/calldata.sol';
import 'factory/user.sol';

contract Builder {
    function build(string typename) returns (DSAuthorized);
}
contract Installer {
    function install( string typename, DSBasicAuthority install_to_authority )
             returns (address);
}
contract Locator {
    function locate(string typename) returns (address);
}

import 'auth/basic_authority.sol';
import 'data/map.sol';
import 'data/nullmap.sol';
import 'data/balance_db.sol';
import 'data/approval_db.sol';
import 'gov/easy_multisig.sol';
import 'token/base.sol';
import 'token/eth_wrapper.sol';
import 'token/controller.sol';
import 'token/frontend.sol';


contract DSFactory {
    // auth builders
    function buildDSBasicAuthority() returns (DSBasicAuthority);

    // data builders
    function buildDSBalanceDB() returns (DSBalanceDB);
    function buildDSApprovalDB() returns (DSApprovalDB);
    function buildDSMap() returns (DSMap);
    function buildDSNullMap() returns (DSNullMap);

    // token builders
    function buildDSTokenController( DSBalanceDB bal_db, DSApprovalDB appr_db )
             returns (DSTokenController);
    function buildDSTokenFrontend( DSTokenController cont )
             returns (DSTokenFrontend);

    // token installers
    function installDSTokenBasicSystem( DSBasicAuthority authority ) 
             returns( DSTokenFrontend token_frontend );

    // token locators
    function locateDSEthToken() returns (DSEthToken);

    // gov builders
    function buildDSEasyMultisig( uint n, uint m, uint expiration ) returns (DSEasyMultisig);
}

// Lets us add Locators (for singletons), Builders, and Installers
// Usage:   var eth_token = DSEthToken(_factory.locate("DSEthToken"));
//          var authority = DSBasicAuthority(_factory.build("DSBasicAuthority"));
//          var frontend = DSTokenFrontend(_factory.install("DSBasicTokenSystem", authority));
contract DSFactoryRouter is DSAuth
                          , DSFactorySetupEnumUser
                          , Builder
                          , Installer
                          , Locator
{
    struct getter {
        address impl;
        DSFactorySetupTypes setup_type;
        bool set;
    }
    mapping(string => getter) _getters;
    function getInfo(bytes4 sig) returns (address impl, DSFactorySetupTypes setup_type, bool set) {
        var getter = _getters[sig];
        return (getter.impl, getter.setup_type, getter.set);
    }
    function set(string typename, address impl, DSFactorySetupTypes setup_type)
             auth()
    {
        // Protect against admins
        if( _getters[typename].set ) {
            throw;
        }
        _getters[typename].impl = impl;
        _getters[typename].setup_type = setup_type;
        _getters[typename].set = true;
    }

    function build(string typename) returns (address) {
        var getter = _getters[typename];
        if( getter.setup_type != DSFactorySetupTypes.Builder ) {
            throw;
        }
        var obj = Builder(getter.impl).build(typename);
        obj.updateAuthority(msg.sender, DSAuthModes.Owner);
        return obj;
    }

    function install(string typename, DSBasicAuthority authority) returns (address)
    {
        var getter = _getters[typename];
        if (getter.setup_type != DSFactorySetupTypes.Installer) {
            throw;
        }
        var installer = Installer(getter.impl);
        authority.updateAuthority( address(installer), DSAuthModes.Owner );
        var frontend = DSTokenFrontend(installer.install( authority );
        authority.updateAuthority( msg.sender, DSAuthModes.Owner );
        return frontend;
    }
    
    function locate(string typename) returns (address)
    {
        var getter = _getters[typename];
        if (getter.setup_type != DSFactorySetupTypes.Locator) {
            throw;
        }
        return Locator(getter.impl).locate(typename); 
    }
}
*/
