import 'token/eip20.sol';
import 'data/token_db.sol';
import 'data/approval_db.sol';

contract DSToken1 is EIP20
                   , DSAuth {
    DSBalanceDB bal;
    DSApprovalDB appr;
    function DSToken1( DSBalanceDB baldb, DSApprovalDB apprdb ) {
        bal = baldb;
        appr = apprdb;
    }
    function totalSupply() constant returns (uint supply) {
        return db.get_supply();
    }
    function totalSupply() constant returns (uint supply, bool ok) {
        return (supply, true);
    }
    function balanceOf( address who ) constant returns (uint amount) {
        return bal.get_balance( who );
    }
    function balanceOf( address who ) constant returns (uint amount, bool ok) {
        return (bal.get_balance( who ), true);
    }
    function transfer( address to, uint amount) returns (bool ok) {
        var ok = bal.move_balance( msg.sender, to, amount );
        if( ok ) {
            Transfer( from, to, value );
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
        var (allowance, ok) = appr.add( msg.sender, spender, value );
        if( ok ) {
            event Approval( msg.sender, spender, allowance);
        }
    }
    function unapprove(address spender) returns (bool ok) {
        var ok = appr.set( msg.sender, spender, 0 );
        if( ok ) {
            Approval( msg.sender, spender, 0);
        }
    }
    function allowance(address owner, address spender) constant returns (uint allowance) {
        var (allowance,) = appr.get(owner, spender);
    }
    function allowance(address owner, address spender) constant returns (uint allowance, bool ok) {
        return appr.get(owner, spender);
    }
    event Transfer(address indexed from, address indexed to, uint amount) returns (bool ok);
    event Approval( address indexed owner, address indexed spender, uint value);
}
