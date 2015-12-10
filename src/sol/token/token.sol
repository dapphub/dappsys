import 'token/eip20.sol';
import 'data/balance_db.sol';
import 'data/approval_db.sol';

contract DSToken1 is EIP20
                   , DSAuth
{
    DSBalanceDB bal;
    DSApprovalDB appr;
    function DSToken1( DSBalanceDB baldb, DSApprovalDB apprdb ) {
        bal = baldb;
        appr = apprdb;
    }
    function totalSupply() constant returns (uint supply) {
        (supply,) = bal.get_supply();
        return supply;
    }
/*
    function totalSupply() constant returns (uint supply, bool ok) {
        return bal.get_supply();
    }
*/
    function balanceOf( address who ) constant returns (uint amount) {
        (amount,) = bal.get_balance( who );
        return amount;
    }
/*
    function balanceOf( address who ) constant returns (uint amount, bool ok) {
        (amount, ok) = bal.get_balance(who);
    }
*/
    function transfer( address to, uint value) returns (bool ok) {
        ok = bal.move_balance( msg.sender, to, value );
        if( ok ) {
            Transfer( msg.sender, to, value );
        }
    }
    function transferFrom( address from, address to, uint value) returns (bool ok) {
        var (allowance, _ok) = appr.get( from, msg.sender );
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
            Approval( msg.sender, spender, allowance);
        }
    }
    function unapprove(address spender) returns (bool ok) {
        ok = appr.set( msg.sender, spender, 0 );
        if( ok ) {
            Approval( msg.sender, spender, 0);
        }
    }
    function allowance(address owner, address spender) constant returns (uint _allowance) {
        (_allowance,) = appr.get(owner, spender);
    }
/*
    function allowance(address owner, address spender) constant returns (uint _allowance, bool ok) {
        (_allowance, ok) = appr.get(owner, spender);
    }
*/
}
