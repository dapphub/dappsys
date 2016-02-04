// An implementation of ERC20 with updateable databases contracts and a frontend
// interface.
import 'data/approval_db.sol';
import 'data/balance_db.sol';
import 'token/erc20.sol';
import 'token/event_callback.sol';
import 'token/frontend.sol';
import 'token/token.sol';

// Does NOT implement stateful ERC20 functions - those require you to pass
// through the msg.sender
contract DSTokenControllerType is ERC20Stateless, ERC20Events {
    // ERC20Stateful proxies
    function transfer( address caller, address to, uint value) returns (bool ok);
    function transferFrom( address caller, address from, address to, uint value) returns (bool ok);
    function approve( address caller, address spender, uint value) returns (bool ok);

    // Administrative functions
    function getFrontend() constant returns (DSTokenFrontend);
    function setFrontend( DSTokenFrontend frontend );
    function getDBs() constant returns (DSBalanceDB, DSApprovalDB);
    function setBalanceDB( DSBalanceDB new_db, address new_authority, bool new_auth_mode );
    function setApprovalDB( DSApprovalDB new_db, address new_authority, bool new_auth_mode );

}

contract DSTokenController is DSTokenControllerType
                            , DSAuth
{
    // Swappable database contracts
    DSBalanceDB                _balances;
    DSApprovalDB               _approvals;
    // Trust calls from this address and report events here.
    DSTokenFrontend            _frontend;

    // Setup and admin functions
    function DSTokenController( DSBalanceDB baldb, DSApprovalDB apprdb ) {
        _balances = baldb;
        _approvals = apprdb;
    }
    function getFrontend() constant returns (DSTokenFrontend) {
        return _frontend;
    }
    function setFrontend( DSTokenFrontend frontend )
             auth()
    {
        _frontend = frontend;
    }
    function getDBs() constant returns (DSBalanceDB, DSApprovalDB) {
        return (_balances, _approvals);
    }
    function setBalanceDB( DSBalanceDB new_db
                         , address new_authority
                         , bool new_auth_mode )
             auth()
    {
        _balances.updateAuthority( new_authority, new_auth_mode );
        _balances = new_db;
    }

    function setApprovalDB( DSApprovalDB new_db
                          , address new_authority
                          , bool new_auth_mode )
             auth()
    {
        _approvals.updateAuthority( new_authority, new_auth_mode );
        _approvals = new_db;
    }



    // Stateless ERC20 functions. Doesn't need to know who the sender is.
    function totalSupply() constant returns (uint supply) {
        return _balances.getSupply();
    }
    function balanceOf( address who ) constant returns (uint amount) {
        return _balances.getBalance( who );
    }
    function allowance(address owner, address spender) constant returns (uint _allowance) {
        return _approvals.get(owner, spender);
    }


    // Each stateful ERC20 function signature has an parallel function
    // which takes a `msg.sender` as the first argument. Each such "implementation"
    // function needs to report any events back to the "frontend" contract.

    // Only trust calls from the frontend contract.
    function transfer( address caller, address to, uint value)
             auth()
             returns (bool ok)
    {
        return transferFrom( caller, caller, to, value );
    }
    function transferFrom( address caller, address from, address to, uint value)
             auth()
             returns (bool)
    {
        var from_balance = _balances.getBalance( from );
        // if you don't have enough balance, return false
        if( from_balance < value ) {
            return false;
        }
        // if you aren't the owner and don't have approval, return false
        if( from != caller ) {
            var allowance = _approvals.get( from, caller );
            if( allowance < value ) {
                return false;
            } else {
                // if you aren't the owner but do have approval, subtract value
                _approvals.set( from, to, allowance - value );
            }
        }
        // transfer and return true
        _balances.moveBalance( from, to, value);
        Transfer( from, to, value );
        _frontend.eventTransfer( from, to, value );
        return true;
    }
    function approve( address caller, address spender, uint value)
             auth()
             returns (bool)
    {
        _approvals.set( caller, spender, value );
        Approval( caller, spender, value);
        _frontend.eventApproval( caller, spender, value );
    }
}
