`dappsys` [![dappsys version](https://img.shields.io/badge/version-0.1.0-8D86C9.svg?style=flat-square)](https://github.com/nexusdev/dappsys/releases/tag/0.1.0) [![Language Solidity](https://img.shields.io/badge/language-solidity-lightgrey.svg?style=flat-square)](https://github.com/ethereum/go-ethereum/wiki/Contracts-and-Transactions#solidity)
===
[![Slack Status](http://slack.makerdao.com/badge.svg)](https://slack.makerdao.com)

`dappsys` is **contract system framework**. It is a collection of Solidity contracts (classes) to help manage multi-contract dapps on ethereum.

Audit
---

On February 24th, 2016, [Piper Merriam](https://keybase.io/pipermerriam)
completed and signed [a code
audit](https://github.com/nexusdev/dappsys/blob/master/nexus-review-final-2016-02-24.md)
 covering the state of Dappsys as of [commit
4dceee5](https://github.com/nexusdev/dappsys/commit/4dceee5272b51744a89009907d5ca85a0a82faed).

Installation
---

    npm install dapple
    dapple install https://github.com/nexusdev/dappsys

How to
---

1.0 Contracts
---

### `auth`:

##### Mixin Types

`DSAuth` or `DSAuthorized`: Mixin contract with the `auth` modifier.

`DSAuthUser`: `DSAuthModesEnum` + `DSAuthorizedEvents` + `DSAuthUtils`

`DSAuthUtils`: Wrappers for `updateAuthority` (`setOwner` and `setAuthority`)

##### Concrete Types

`DSBasicAuthority`: Simple `DSAuthority` implementation with `setCanCall(caller, code, sig, can_call)`

##### Abstract Types:


`DSAuthority`: `canCall(caller, code, sig) returns (cal_call)`

`DSAuthorizedEvents`: Event definitions for `DSAuthorized` events.

`DSAuthModesEnum`: Enum definition for `DSAuthModes`.



### `actor`:

##### Mixin Types

`DSBaseActor`: `exec` and `tryExec`, wrappers around `.call`.


### `data`:

##### Concrete Types

`DSMap`: word-sized keys to word-sized values

`DSNullMap`: Nullable version of `DSMap`. Throws on null `get`, has `tryGet` with error return argument.

`DSBalanceDB`: Typed map for "balances" (set/add/subtract/move), used with `token`

`DSApprovalDB`: Typed map for "approvals" (set), used with `token`

### `factory`:

##### Singletons

`DSFactory1`: Factories for most types in v1. TODO special usage for `install` vs `build`

### `gov`:

##### Concrete Types

`DSEasyMultisig`: A multisig actor optimized for ease of use.


### `token`

##### Abstract Types

`ERC20`: Token standard: https://github.com/ethereum/EIPs/issues/20

`ERC20Stateful`: Subset of `ERC20` which affects state and also depends on `msg.sender`.

`ERC20Stateless`: Subset of `ERC20` which are getters that do not affect state and do not depend on `msg.sender`.

`ERC20Events`: Type that contains `ERC20` event definitions.


`DSToken`: alias for `ERC20`


`DSTokenControllerType`: Variants of `ERC20Stateful` with an extra `_caller` argument.

`DSTokenEventCallback`: `emitX` for `X` in `ERC20Events`

##### Concrete Types

`DSTokenRegistry`: `DSTokenProvider` implementation - a `DSNullMap` with `getToken`, address-returning alias for `get`.

`DSTokenFrontend`: A proxy contract for `ERC20`/`DSToken` which forwards to a set `DSTokenControllerType`. See `factory/token_installer.sol`.

`DSTokenController`: A `DSTokeControllerType` implementation which implements minimal `ERC20` logic. See `factory/token_installer.sol`.

##### Mixin Types

`DSTokenProviderUser`: `DSToken` functions with an extra `bytes32 symbol` argument, plus some extra helper mixins and internal functions for common token usages.

`DSTokenBase`: A base contract for single-contract token implementations.

##### Singletons

`DSEthToken`: A contract which wraps the native ether functionality in an `ERC20`-compliant Token contract.
