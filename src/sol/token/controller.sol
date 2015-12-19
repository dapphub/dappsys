// An implementation of ERC20 with updateable databases contracts.
import 'auth/auth.sol';
import 'token/token.sol';
import 'token/proxy.sol';

contract DSTokenController is DSTokenProxyAcceptor
                            , DSAuth
{
    DSBalanceDB public bal;
    DSApprovalDB public appr;
    mapping( address => bool ) proxies;
    function DSTokenController( DSBalanceDB baldb, DSApprovalDB apprdb ) {
        bal = baldb;
        appr = apprdb;
    }
    function totalSupply() constant returns (uint supply) {
        bool ok;
        (supply, ok) = bal.get_supply();
        if( !ok ) throw;
        return supply;
    }
    function balanceOf( address who ) constant returns (uint amount) {
        bool ok;
        (amount, ok) = bal.get_balance( who );
        if( !ok ) throw;
        return amount;
    }
    function transfer( address to, uint value) returns (bool ok) {
        ok = bal.move_balance( msg.sender, to, value );
        if( ok ) {
            Transfer( msg.sender, to, value );
        }
    }
    function transferFrom( address from, address to, uint value) returns (bool ok) {
        uint allowance;
        (allowance, ok) = appr.get( from, msg.sender );
        if( ok ) {
            ok = bal.move_balance( from, to, value);
            if( ok ) {
                Transfer( from, to, value );
            }
        }
    }
    function approve(address spender, uint value) returns (bool ok) {
        uint allowance;
        (allowance, ok) = appr.add( msg.sender, spender, value );
        if( ok ) {
            Approved( msg.sender, spender, allowance);
        }
    }
    function unapprove(address spender) returns (bool ok) {
        ok = appr.set( msg.sender, spender, 0 );
        if( ok ) {
            Unapproved( msg.sender, spender );
        }
    }
    function allowance(address owner, address spender) constant returns (uint _allowance) {
        var (allowance, ok) = appr.get(owner, spender);
        if( !ok ) throw;
        return allowance;
    }

    // Proxy functions

    function transfer( address caller, address to, uint value)
             proxies_only() 
             returns (bool ok)
    {
        ok = bal.move_balance( caller, to, value );
        if( ok ) {
            Transfer( caller, to, value );
        }
    }
    function transferFrom( address caller, address from, address to, uint value)
             proxies_only()
             returns (bool ok)
    {
        uint allowance;
        (allowance, ok) = appr.get( from, caller );
        if( ok ) {
            ok = bal.move_balance( from, to, value);
            if( ok ) {
                Transfer( from, to, value );
            }
        }
    }
    function approve( address caller, address spender, uint value)
             proxies_only()
             returns (bool ok)
    {
        uint allowance;
        (allowance, ok) = appr.add( caller, spender, value );
        if( ok ) {
            Approved( caller, spender, allowance);
        }
    }
    function unapprove( address caller, address spender)
             proxies_only()
             returns (bool ok)
    {
        ok = appr.set( caller, spender, 0 );
        if( ok ) {
            Unapproved( caller, spender );
        }
    }

    modifier proxies_only() {
        if( proxies[msg.sender] ) {
            _
        }
    }
    function setApprovedProxy( DSTokenProxy proxy, bool allow )
             auth()
             returns (bool ok)
    {
        proxies[proxy] = allow;
    }
    function updateDBs( DSBalanceDB new_bal_db, address new_bal_auth, uint8 new_bal_auth_mode
                      , DSApprovalDB new_appr_db, address new_appr_auth, uint8 new_appr_auth_mode )
             auth()
             returns (bool)
    {
        var ok = bal._ds_update_authority( new_bal_auth, new_bal_auth_mode );
        if( ok ) {
            bal = new_bal_db;
        }
        ok = appr._ds_update_authority( new_appr_auth, new_appr_auth_mode );
        if( ok ) {
            appr = new_appr_db;
        }
        return true;
    }
}
