`dappsys`
===
`dappsys` is **contract system framework**. It is a collection of Solidity contracts (classes) to help manage multi-contract dapps on ethereum.

This project is under active development and changes quickly on branch `develop`.Tag `0.1.2` was audited. Tag `0.2.0` is the last versioned release. Branch `latest-stable` is stable.

Installation
---

    npm install -g dapple
    mkdir myproject && cd myproject && mkdir dapple_packages
    git submodule add https://github.com/nexusdev/dappsys dapple_packages/dappsys

Overview
---

Dappsys contracts are designed to be *composable* in two ways:

* "Within" a contract (solidity-level `contract`): Many dappsys contracts are "mixin" contracts, and many contracts are defined simply by inheriting from multiple contracts with minimal additional logic
* "Between" contracts (deployed autonomous objects): Contracts do one thing and one thing well. They have a minimal interface out of which consumers create higher-level abstractions. Any universal contracts ("objects" at the dappfile level) look like low-level infrastructure services (e.g. factories or an ETH erc20 wrapper).

There is a high-level overview of contracts in 0.2.0 here: https://github.com/nexusdev/dappsys/wiki/0.2.0-contracts


Major Concepts
---
work in progress

### Authorization
Start with `contracts/auth/authorized.sol`.

### Datastore / Controller / Frontend separation
Look at the token system, `contracts/token/controller.sol` and `contracts/token/frontend.sol`.

### Data
Especially `contracts/data/nullmap.sol`

### Component, Environment
### Factories, Installers
