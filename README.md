`dappsys`
===
`dappsys` is **contract system framework**. It is a collection of Solidity contracts (classes) to help manage multi-contract dapps on ethereum.

This project is under active development and changes quickly on branch `develop`.Tag `0.1.2` was audited. Tag `0.2.0` is the last versioned release. Branch `latest-stable` is stable.

Installation
---

    npm install -g dapple
    # `dapple install` is not reliable yet
    # dapple install nexusdev/dappsys@develop
    git submodule add https://github.com/nexusdev/dappsys dapple_packages/dappsys

Diving in
---

This project is about 6 months behind on documentation. The more stable parts of the codebase are well documented with comments.

Dappsys contracts are designed to be *composable* in two ways:

* "Within" a contract (solidity-level `contract`): Many dappsys contracts are "mixin" contracts, and many contracts are defined simply by inheriting from multiple contracts with minimal additional logic
* "Between" contracts (deployed autonomous objects): Contracts do one thing and one thing well. They have a minimal interface out of which consumers create higher-level abstractions. Any universal contracts ("objects" at the dappfile level) look like low-level infrastructure services (e.g. factories or an ETH erc20 wrapper).

The best place to start is `contracts/auth/authorized.sol`.

After that, take a look at the token system, `contract/token/controller.sol` and `contracts/token/frontend.sol`.

There is a high-level overview of contracts in 0.2.0 here: https://github.com/nexusdev/dappsys/wiki/0.2.0-contracts
