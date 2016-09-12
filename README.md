`dappsys`
===

`dappsys` is a collection of building blocks for building smart contract systems.

Dappsys components are exposed as [dapple packages](). They are written in solidity, but deployed objects can be linked to any language.

Dappsys contracts are designed to be *composable* in two ways:

* "Within" a contract (solidity-level `contract`): Many dappsys contracts are "mixin" contracts, and many contracts are defined simply by inheriting from multiple contracts with minimal additional logic
* "Between" contracts (deployed autonomous objects): Contracts do one thing and one thing well. They have a minimal interface out of which consumers create higher-level abstractions. Any universal contracts ("objects" at the dappfile level) look like low-level infrastructure services (e.g. factories or an ETH erc20 wrapper).


Using
---

    npm install -g dapple
    mkdir myproject && cd myproject
    dapple init
    git submodule add https://github.com/nexusdev/dappsys .dapple/packages/dappsys
    git submodule update --init --recursive
