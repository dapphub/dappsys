// An implementation of ERC20 with updateable databases contracts and a frontend
// interface.
import 'data/approval_db.sol';
import 'data/balance_db.sol';
import 'token/erc20.sol';
import 'token/event_callback.sol';
import 'token/frontend.sol';
import 'token/token.sol';

contract DSTokenControllerType is ERC20Stateless, ERC20Events {
    // ERC20Stateful proxies
    function transfer( address caller, address to, uint value) returns (bool ok);
    function transferFrom( address caller, address from, address to, uint value) returns (bool ok);
    function approve( address caller, address spender, uint value) returns (bool ok);

    // Administrative functions
    function getFrontend() constant returns (DSTokenFrontend);
    function setFrontend( DSTokenFrontend frontend ) returns (bool);
    function getDBs() constant returns (DSBalanceDB, DSApprovalDB);
    function setBalanceDB( DSBalanceDB new_db, address new_authority, bool new_auth_mode ) returns (bool);
    function setApprovalDB( DSApprovalDB new_db, address new_authority, bool new_auth_mode ) returns (bool);

}

// Does NOT implement stateful ERC20 functions - those require you to pass
// through the msg.sender
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
             returns (bool ok)
    {
        _frontend = frontend;
        return true;
    }
    function getDBs() constant returns (DSBalanceDB, DSApprovalDB) {
        return (_balances, _approvals);
    }
    function setBalanceDB( DSBalanceDB new_db
                         , address new_authority
                         , bool new_auth_mode )
             auth()
             returns (bool)
    {
        var ok = _balances.updateAuthority( new_authority, new_auth_mode );
        if( ok ) {
            _balances = new_db;
            return true;
        }
        return false;
    }

    function setApprovalDB( DSApprovalDB new_db
                          , address new_authority
                          , bool new_auth_mode )
             auth()
             returns (bool)
    {
        var ok = _approvals.updateAuthority( new_authority, new_auth_mode );
        if( ok ) {
            _approvals = new_db;
            return true;
        }
        return false;
    }



    // Stateless ERC20 functions. Doesn't need to know who the sender is.
    function totalSupply() constant returns (uint supply) {
        bool ok;
        (supply, ok) = _balances.getSupply();
        if( !ok ) throw;
        return supply;
    }
    function balanceOf( address who ) constant returns (uint amount) {
        bool ok;
        (amount, ok) = _balances.getBalance( who );
        if( !ok ) throw;
        return amount;
    }
    function allowance(address owner, address spender) constant returns (uint _allowance) {
        var (allowance, ok) = _approvals.get(owner, spender);
        if( !ok ) throw;
        return allowance;
    }


    // Each stateful ERC20 function signature has an parallel function
    // which takes a `msg.sender` as the first argument. Each such "implementation"
    // function needs to report any events back to the "frontend" contract.

    // Only trust calls from the frontend contract.
    modifier frontend_only() {
        if( msg.sender == address(_frontend) ) {
            _
        }
    }
    function transfer( address caller, address to, uint value)
             frontend_only()
             returns (bool ok)
    {
        return transferFrom( caller, caller, to, value );
    }
    function transferFrom( address caller, address from, address to, uint value)
             frontend_only()
             returns (bool)
    {
        var (bal, ok) = _balances.getBalance( from );
        if( bal >= value ) {
            uint allowance;
            (allowance, ok) = _approvals.get( from, caller );
            bool hasApproval = (ok && allowance >= value);
        }
        if( hasApproval ) {
            _approvals.set( from, to, allowance - value );
        }
        if( from == caller || hasApproval ) {
            ok = _balances.moveBalance( from, to, value);
            if( ok ) {
                Transfer( from, to, value );
                _frontend.eventTransfer( from, to, value );
                return true;
            }
        }
        return false;
    }
    function approve( address caller, address spender, uint value)
             frontend_only()
             returns (bool)
    {
        var ok = _approvals.set( caller, spender, value );
        if( ok ) {
            Approval( caller, spender, value);
            _frontend.eventApproval( caller, spender, value );
            return true;
        }
        return false;
    }
}
