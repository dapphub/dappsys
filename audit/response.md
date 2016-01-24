This is a summary of changes made due to recommendations in section 4 of the report. "Major" issues are starred.
Test coverage is addressed in a separate document.


1.1) accepted
1.2) accepted

2.1) possibly accept - TODO discussion about public enums
2.2) accept ^^
2.3) accept some variant  TODO discussion about enums
2.4) possibly reject - isn't this useful for natspec?
2.5) see 2.4
2.6) accepted
2.7) discuss - could be confusing since _authority is often a key or direct-owner which doesn't implement `DSAuthority`. A union type would be more appropriate, a dependent type on `mode`
2.8) accept for later version - delete for re-review

* 3.1) accept.
3.2) N/A if 3.1 accepted.
3.3) accept: use "caller_address" vs "code_address"
3.4) possibly reject  TODO discussion about marking functions constant on general interfaces (ie `canCall` w/ a counter)
3.5) bad copy/paste of 3.6? This is not true, would be critical if it were, and the fix makes no sense
3.6) possibly reject in connection with 
3.7) accept

4.1) reject, it is specifically not an ERC20 implementation and these functions could not be renamed to match the ERC20 signatures without being misleading
* 4.2) accept, this is an artifact of when BalanceDBs had stronger assumptions
4.3) probably accept, it is acceptable for these functions to throw, but need to think some more
4.4) accept
4.5) accept
4.6) accept

5.1) possibly reject - it wouldn't actually be conforming to ERC20 anyway b/c they take extra arguments. I'm not convinced it makes it easier to understand. See 4.1.
5.2) accept
5.3) reject, this is an interface that can fail  TODO should it then be defined as such elsewhere?
5.4) reject, see 5.3


* 6.1+6.2) accept (delete) The purpose of this contract is to mark contracts that *should* only exist for one transaction. However this makes things strictly less safe and is just a bad idea.
* 6.3) accept (delete)
6.4) accept (delete)

7.1) requires discussion
7.2) probably accept, but see 3.4 and similar
7.3) accept
7.4) accept
7.5) "error codes on interfaces" discussion

8.1) accept
* 8.2) accept
* 8.3) accept

9.1) reject - future-proofing concerns (see 3.4, 7.2 etc)
9.2) reject - future-proofing concerns (see 3.4, 7.2 etc)
9.3) reject - future-proofing concerns (see 3.4, 7.2 etc)
9.4) reject - future-proofing concerns (see 3.4, 7.2 etc)

* 9.5) accept

10.1) accept
...
* 10.5) accept
* 10.6) possibly accept - is this situation actually possible?
