## Tested and Documented:

### `auth`

Base command-and-control contracts. 

tests/docs
* `auth/auth.sol`
* `auth/authority.sol`
* `auth/basic_authority.sol`

design
* `auth/group_authority.sol`


### `data`

Database contracts.

tests/docs
* `data/approval_db.sol`
* `data/balance_db.sol`

design
* `data/auth_db.sol`

### `token`

impl:
`token/eip20.sol`
`token/token.sol`


### `kern`

This contract will be a "fully dynamic object". The creator owns a contract which can be modified arbitraily, including the ability to "solidify" and constrain its ability to change itself. It is the union of several generalizations:

* A *dynamic ABI* (`dynin`)
* Ability to do *dynamic calls* (`dynout`)
* Ability to do *dynamic events* (`dynlog`)
* A managed subsystem (`auth`)

The value of the first 3 components is that together that they let you simulate any compiled contract, modulo gas cost and stack depth.
The `auth` component is a simple set of conventions for contract command-and-control.

[1] certain restrictions in the Solidity language definition prevent us from creating this contract in pure Solidity. For now, the Kernel is split into component contracts, giving you several workaround options. Fortunately these critical features are still on the official solidity roadmap.


### `lang`

Tests to explore solidity's corner cases, and some helper mixins.

### `util`

misc utilities
