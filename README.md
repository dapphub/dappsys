`dappsys`
===
[![Slack Status](http://slack.makerdao.com/badge.svg)](https://slack.makerdao.com)

`dappsys` is **contract system framework**. It is a collection of Solidity contracts (classes) to help manage multi-contract dapps on ethereum.

Installation
---

This will work Soon:

    npm install dapple
    dapple install dappsys

Modules
---

### v1 modules
#### `auth`

Base command-and-control contracts. 

tests/docs
* `auth/auth.sol`
* `auth/authority.sol`
* `auth/basic_authority.sol`

design
* `auth/group_authority.sol`


#### `data`

Database contracts.

tests/docs
* `data/approval_db.sol`
* `data/balance_db.sol`
* `data/map.sol`

design
* `data/auth_db.sol`

#### `gov`

* multisig
* stake-vote

#### `token`

impl:
* `token/base.sol`
* `token/controller.sol`
* `token/erc20.sol`
* `token/eth_wrapper.sol`
* `token/proxy.sol`
* `token/token.sol`

design
`token/system.sol`
`token/user.sol`




### v2 plans
#### `kern`

This contract will be a "fully dynamic object". The creator owns a contract which can be modified arbitraily, including the ability to "solidify" and constrain its ability to change itself. It is the union of several generalizations:

* A *dynamic ABI* (`dynin`)
* Ability to do *dynamic calls* (`dynout`)
* Ability to do *dynamic events* (`dynlog`)
* A managed subsystem (`auth`)

The value of the first 3 components is that together that they let you simulate any compiled contract, modulo gas cost and stack depth.
The `auth` component is a simple set of conventions for contract command-and-control.

[1] certain restrictions in the Solidity language definition prevent us from creating this contract in pure Solidity. For now, the Kernel is split into component contracts, giving you several workaround options. Fortunately these critical features are still on the official solidity roadmap.


#### `lang`

Tests to explore solidity's corner cases, and some helper mixins.

#### `util`

misc utilities
