# Section 1 - Table of Contents<a id="heading-0"/>

* 1 - [Table of Contents](#heading-0)
* 2 - [Introduction](#heading-2)
    * 2.1 - [Audit Goals](#heading-2.1)
        * 2.1.1 - [Sound Architecture](#heading-2.1.1)
        * 2.1.2 - [Code Correctness and Quality](#heading-2.1.2)
        * 2.1.3 - [Security](#heading-2.1.3)
        * 2.1.4 - [Phase 1 Deployer Contract](#heading-2.1.4)
    * 2.2 - [Source Code](#heading-2.2)
        * 2.2.1 - [File List](#heading-2.2.1)
    * 2.3 - [Framework Components and Concepts](#heading-2.3)
        * 2.3.1 - [Authority](#heading-2.3.1)
        * 2.3.2 - [Authorized](#heading-2.3.2)
        * 2.3.3 - [Databases](#heading-2.3.3)
        * 2.3.4 - [Tokens (ERC20)](#heading-2.3.4)
        * 2.3.5 - [Actor](#heading-2.3.5)
        * 2.3.6 - [Multisig Governance](#heading-2.3.6)
        * 2.3.7 - [Factory Contracts](#heading-2.3.7)
        * 2.3.8 - [Deployer Contract](#heading-2.3.8)
    * 2.4 - [Quick Left and Piper Merriam](#heading-2.4)
        * 2.4.1 - [Open Source Work](#heading-2.4.1)
        * 2.4.2 - [Populus](#heading-2.4.2)
        * 2.4.3 - [Ethereum Alarm Clock](#heading-2.4.3)
    * 2.5 - [Links](#heading-2.5)
    * 2.6 - [Terminology](#heading-2.6)
        * 2.6.1 - [Coverage](#heading-2.6.1)
            * 2.6.1.1 - [**untested**](#heading-2.6.1.1)
            * 2.6.1.2 - [**low**](#heading-2.6.1.2)
            * 2.6.1.3 - [**good**](#heading-2.6.1.3)
            * 2.6.1.4 - [**excellent**](#heading-2.6.1.4)
        * 2.6.2 - [Severity](#heading-2.6.2)
            * 2.6.2.1 - [**minor**](#heading-2.6.2.1)
            * 2.6.2.2 - [**medium**](#heading-2.6.2.2)
            * 2.6.2.3 - [**major**](#heading-2.6.2.3)
            * 2.6.2.4 - [**critical**](#heading-2.6.2.4)
* 3 - [Main Findings](#heading-3)
    * 3.1 - [Primary Issues](#heading-3.1)
        * 3.1.1 - [Static Return Values](#heading-3.1.1)
        * 3.1.2 - [Database Contracts have no first class mechanism to freeze state](#heading-3.1.2)
        * 3.1.3 - [Lack of inline comments](#heading-3.1.3)
        * 3.1.4 - [Token contracts have very low test coverage](#heading-3.1.4)
        * 3.1.5 - [Events are not tested](#heading-3.1.5)
        * 3.1.6 - [dapple](#heading-3.1.6)
            * 3.1.6.1 - [Sparse Documentation](#heading-3.1.6.1)
            * 3.1.6.2 - [No Apparent CI](#heading-3.1.6.2)
            * 3.1.6.3 - [Solidity Based Tests](#heading-3.1.6.3)
        * 3.1.7 - [Named vs Un-named return values](#heading-3.1.7)
    * 3.2 - [Test Coverage Analysis](#heading-3.2)
        * 3.2.1 - [DSBaseActor](#heading-3.2.1)
        * 3.2.2 - [DSBasicAuthority](#heading-3.2.2)
            * 3.2.2.1 - [Whitelist feature is not covered](#heading-3.2.2.1)
        * 3.2.3 - [DSAuthorized](#heading-3.2.3)
            * 3.2.3.1 - [Add precondition checks](#heading-3.2.3.1)
            * 3.2.3.2 - [`testNonOwnerCantBreach` has no assertions](#heading-3.2.3.2)
        * 3.2.4 - [DSStaticAuthorized](#heading-3.2.4)
        * 3.2.5 - [DSBalanceDB](#heading-3.2.5)
            * 3.2.5.1 - [No coverage for failure case of `moveBalance`](#heading-3.2.5.1)
            * 3.2.5.2 - [No coverage for tracking of overall supply](#heading-3.2.5.2)
            * 3.2.5.3 - [`moveBalance` coverage does not check source account was debited](#heading-3.2.5.3)
        * 3.2.6 - [DSApprovalDB](#heading-3.2.6)
        * 3.2.7 - [`DSModifiers`](#heading-3.2.7)
        * 3.2.8 - [`DSEphemeral`](#heading-3.2.8)
        * 3.2.9 - [`DSTrueFallback`](#heading-3.2.9)
        * 3.2.10 - [`DSFalseFallback`](#heading-3.2.10)
        * 3.2.11 - [`DSTokenBase`](#heading-3.2.11)
            * 3.2.11.1 - [All coverage is implemented as a single test case](#heading-3.2.11.1)
        * 3.2.12 - [`DSTokenController`](#heading-3.2.12)
            * 3.2.12.1 - [No coverage for frontend setter and getter](#heading-3.2.12.1)
            * 3.2.12.2 - [No coverage for database update](#heading-3.2.12.2)
        * 3.2.13 - [`DSTokenFrontend`](#heading-3.2.13)
            * 3.2.13.1 - [No coverage for controller getter and setter](#heading-3.2.13.1)
        * 3.2.14 - [`EthToken`](#heading-3.2.14)
        * 3.2.15 - [`DSTokenDeployer`](#heading-3.2.15)
            * 3.2.15.1 - [No coverage for non ERC20 functionality](#heading-3.2.15.1)
    * 3.3 - [General Thoughts](#heading-3.3)
        * 3.3.1 - [Authority System](#heading-3.3.1)
        * 3.3.2 - [Frontend/Controller/DB Pattern](#heading-3.3.2)
        * 3.3.3 - [Easy Multisignature Governance](#heading-3.3.3)
        * 3.3.4 - [Testing and Coverage](#heading-3.3.4)
        * 3.3.5 - [Deployer Pattern](#heading-3.3.5)
* 4 - [Detailed Findings](#heading-4)
    * 4.1 - [Source File: `src/sol/actor/base_actor.sol`](#heading-4.1)
        * 4.1.1 - [`DSSimpleActor` seems to be a contract specifically for testing](#heading-4.1.1)
        * 4.1.2 - [`DSBaseActor.exec` declares a named return value but does not use it](#heading-4.1.2)
    * 4.2 - [Source File: `src/sol/auth/authorized.sol](#heading-4.2)
        * 4.2.1 - [`DSAuthorized._authority` is not public](#heading-4.2.1)
        * 4.2.2 - [`DSAuthorized._auth_mode` is not public](#heading-4.2.2)
        * 4.2.3 - [`DSAuthorized._auth_mode` is a boolean](#heading-4.2.3)
        * 4.2.4 - [`DSAuthorized.getAuthority` has unused named return value](#heading-4.2.4)
        * 4.2.5 - [`DSAuthorized.isAuthorized` has unused named return value](#heading-4.2.5)
        * 4.2.6 - [`DSAuthorized.isAuthorized` implicitly returns false](#heading-4.2.6)
        * 4.2.7 - [`DSAuthorized._authority` is of type `address`](#heading-4.2.7)
        * 4.2.8 - [`DSStaticAuthorized` could be eliminated](#heading-4.2.8)
    * 4.3 - [Source File: `src/sol/auth/basic_authority.sol`](#heading-4.3)
        * 4.3.1 - [`DSBasicAuthority.canCall` susceptible to collision](#heading-4.3.1)
        * 4.3.2 - [`DSBasicAuthority.canCall` should use constant value in place of `0x0000`](#heading-4.3.2)
        * 4.3.3 - [`DSBasicAuthority` caller and callee variable names are easy to transpose](#heading-4.3.3)
        * 4.3.4 - [`DSBasicAuthority.canCall` is not marked as `constant`](#heading-4.3.4)
        * 4.3.5 - [`DSBasicAuthority.canCall` always returns `true`](#heading-4.3.5)
        * 4.3.6 - [`DSBasicAuthority.setCanCall` always returns `true`](#heading-4.3.6)
        * 4.3.7 - [`DSBasicAuthority.exportAuthorized` can be removed](#heading-4.3.7)
    * 4.4 - [Source File: `src/sol/data/balance_db.sol`](#heading-4.4)
        * 4.4.1 - [`DSBalanceDB` does not conform to [ERC 20](https://github.com/ethereum/EIPs/issues/20)](#heading-4.4.1)
        * 4.4.2 - [`DSBalanceDB` overflow protection](#heading-4.4.2)
        * 4.4.3 - [`DSBalanceDB.getSupply` and `DSBalanceDB.getBalance` return extra boolean](#heading-4.4.3)
        * 4.4.4 - [`DSBalanceDB.addBalance` declares a named return value but does not use it](#heading-4.4.4)
        * 4.4.5 - [`DSBalanceDB.subBalance` declares a named return value but does not use it](#heading-4.4.5)
        * 4.4.6 - [`DSBalanceDB.moveBalance` declares a named return value but does not use it](#heading-4.4.6)
    * 4.5 - [Source File: `src/sol/data/approval_db.sol`](#heading-4.5)
        * 4.5.1 - [`DSApprovalDB` does not conform to [ERC 20](https://github.com/ethereum/EIPs/issues/20)](#heading-4.5.1)
        * 4.5.2 - [`DSApprovalDB.set` does not log any events on approvals](#heading-4.5.2)
        * 4.5.3 - [`DSApprovalDB.set` returns constant boolean value](#heading-4.5.3)
        * 4.5.4 - [`DSApprovalDB.get` returns constant boolean value as second argument](#heading-4.5.4)
    * 4.6 - [Source File: `src/sol/util/ephemer.sol`](#heading-4.6)
        * 4.6.1 - [`DSEphemeral` uses non-standard suicide function](#heading-4.6.1)
        * 4.6.2 - [`DSEphemeral.cleanUp` can be called by anyone](#heading-4.6.2)
        * 4.6.3 - [`DSModifiers.contracts_only` is trivial to circumvent](#heading-4.6.3)
        * 4.6.4 - [`DSModifiers.keys_only` is a potentially dangerous pattern](#heading-4.6.4)
    * 4.7 - [Source File: `src/sol/data/map.sol`](#heading-4.7)
        * 4.7.1 - [`DSMap` does not distinguish between unset and `0x0`](#heading-4.7.1)
        * 4.7.2 - [`DSMap.get` is not marked as `constant`](#heading-4.7.2)
        * 4.7.3 - [`DSMap.get` declares a named return value but does not use it](#heading-4.7.3)
        * 4.7.4 - [`DSMap.set` declares a named return value but does not use it](#heading-4.7.4)
        * 4.7.5 - [`DSMap.set` always returns `true`](#heading-4.7.5)
    * 4.8 - [Source File: `src/sol/token/base.sol`](#heading-4.8)
        * 4.8.1 - [`DSTokenBase.transfer` has implicit return value of `false`](#heading-4.8.1)
        * 4.8.2 - [`DSTokenBase.transfer` does not perform any overflow checking](#heading-4.8.2)
        * 4.8.3 - [`DSTokenBase.transferFrom` does not perform any overflow checking](#heading-4.8.3)
    * 4.9 - [Source File: `src/sol/token/controller.sol`](#heading-4.9)
        * 4.9.1 - [`DSTokenController.totalSupply` has unreachable `throw` statement](#heading-4.9.1)
        * 4.9.2 - [`DSTokenController.balanceOf` has unreachable `throw` statement](#heading-4.9.2)
        * 4.9.3 - [`DSTokenController.allowance` has unreachable `throw` statement](#heading-4.9.3)
        * 4.9.4 - [`DSTokenController.approve` has unreachable `return false` statement](#heading-4.9.4)
        * 4.9.5 - [`DSTokenController.updateDBs` updates both database contracts](#heading-4.9.5)
    * 4.10 - [Source File: `src/sol/token/frontend.sol`](#heading-4.10)
        * 4.10.1 - [`DSTokenFrontend.eventCallback` is an unnecessary abstraction](#heading-4.10.1)
        * 4.10.2 - [N/A](#heading-4.10.2)
        * 4.10.3 - [N/A](#heading-4.10.3)
        * 4.10.4 - [`src/sol/token/eth_wrapper.sol`](#heading-4.10.4)
        * 4.10.5 - [`EthToken.withdraw` does not support withdrawal to addresses of other contracts with fallback functions](#heading-4.10.5)
        * 4.10.6 - [`EthToken.withdraw` does not perform underflow protection](#heading-4.10.6)
        * 4.10.7 - [`EthToken.withdraw` does not allow full withdrawal of funds](#heading-4.10.7)
        * 4.10.8 - [`EthToken.withdraw` does not handle the failure of `address.send`](#heading-4.10.8)
        * 4.10.9 - [`EthToken._supply` duplicates `this.balance`](#heading-4.10.9)
    * 4.11 - [`src/sol/gov/easy_multisig.sol`](#heading-4.11)
        * 4.11.1 - [`DSEasyMultisig.confirm` always tries to execute the action](#heading-4.11.1)
        * 4.11.2 - [`DSEasyMultisig.confirm` does not validate `action_id` parameter](#heading-4.11.2)
        * 4.11.3 - [`DSEasyMultisig.confirm` can be called on expired actions](#heading-4.11.3)
        * 4.11.4 - [`DSEasyMultisig.confirm` can be called on actions that have already been triggered](#heading-4.11.4)
        * 4.11.5 - [`DSEasyMultisig.trigger` can be executed multiple times](#heading-4.11.5)
        * 4.11.6 - [`DSEasyMultisig.trigger` marks the action as triggered after its execution](#heading-4.11.6)
        * 4.11.7 - [`DSEasyMultisig.trigger` is susceptible to stack depth attacks](#heading-4.11.7)
        * 4.11.8 - [`DSEasyMultisig.trigger` will always fail in certain conditions](#heading-4.11.8)
        * 4.11.9 - [`DSEasyMultisig` allows for actions that cannot be triggered within a certain gas limit](#heading-4.11.9)
        * 4.11.10 - [`DSEasyMultisig.trigger` does not enforce the gas value](#heading-4.11.10)
        * 4.11.11 - [`DSEasyMultisig.trigger` does not enforce the ether value](#heading-4.11.11)
    * 4.12 - [`src/sol/token/deployer.sol`](#heading-4.12)
        * 4.12.1 - [`DSTokenDeployer`](#heading-4.12.1)
* 5 - [Maker Phase 1 Deployer](#heading-5)
    * 5.1 - [`contracts/deployers/phase_1.sol`](#heading-5.1)
        * 5.1.1 - [Creation of Authority contract](#heading-5.1.1)
        * 5.1.2 - [Creation of multi-signature contract for administration.](#heading-5.1.2)
        * 5.1.3 - [Creation of multi-signature contract for fund management.](#heading-5.1.3)
        * 5.1.4 - [ERC20 Token System for `MKR` Token](#heading-5.1.4)
        * 5.1.5 - [ERC20 Token System for `DAI` Token](#heading-5.1.5)
        * 5.1.6 - [Token Registry](#heading-5.1.6)
    * 5.2 - [Deployment Analysis](#heading-5.2)
        * 5.2.1 - [Constructor Arguments](#heading-5.2.1)
        * 5.2.2 - [Steps](#heading-5.2.2)
    * 5.3 - [Deployment Issues](#heading-5.3)
        * 5.3.1 - [Variables are not marked as `public`](#heading-5.3.1)
        * 5.3.2 - [`suicide` makes auditing more difficult.](#heading-5.3.2)
        * 5.3.3 - [DSEasyMultisig is unsafe to use in its current state](#heading-5.3.3)
        * 5.3.4 - [ACL rules between Frontend, Controller, and Database violate "Principle of least Privilege"](#heading-5.3.4)
        * 5.3.5 - [Test coverage is low](#heading-5.3.5)
* 6 - [Follow Up dappsys Audit](#heading-6)
    * 6.1 - [Terminology](#heading-6.1)
        * 6.1.1 - [Status: Resolved](#heading-6.1.1)
        * 6.1.2 - [Status: Unchanged](#heading-6.1.2)
        * 6.1.3 - [Status: Needs Work](#heading-6.1.3)
    * 6.2 - [Test Coverage](#heading-6.2)
        * 6.2.1 - [`DSBaseActor` test coverage](#heading-6.2.1)
        * 6.2.2 - [`DSBasicAuthority` test coverage](#heading-6.2.2)
        * 6.2.3 - [`DSAuthorized` test coverage](#heading-6.2.3)
        * 6.2.4 - [`DSStaticAuthorized` test coverage](#heading-6.2.4)
        * 6.2.5 - [`DSBalanceDB` test coverage](#heading-6.2.5)
        * 6.2.6 - [`DSModifiers` test coverage](#heading-6.2.6)
        * 6.2.7 - [`DSEphemeral` test coverage](#heading-6.2.7)
        * 6.2.8 - [`DSTrueFallback` and `DSFalseFallback` test coverage](#heading-6.2.8)
        * 6.2.9 - [`DSTokenBase` test coverage](#heading-6.2.9)
        * 6.2.10 - [`DSTokenController` and `DSTokenFrontend` test coverage](#heading-6.2.10)
        * 6.2.11 - [`DSEthToken` test coverage](#heading-6.2.11)
        * 6.2.12 - [`DSTokenDeployer` test coverage](#heading-6.2.12)
    * 6.3 - [Minor Issues](#heading-6.3)
        * 6.3.1 - [Static Return Values](#heading-6.3.1)
        * 6.3.2 - [dapple does not test events](#heading-6.3.2)
        * 6.3.3 - [Named vs Un-Named return values](#heading-6.3.3)
        * 6.3.4 - [`DSSimpleActor` is for testing.](#heading-6.3.4)
        * 6.3.5 - [`DSBaseActor.exec` named return value.](#heading-6.3.5)
        * 6.3.6 - [`DSAuthorized._authority` and `DSAuthority._auth_mode` are not public.](#heading-6.3.6)
        * 6.3.7 - [`DSAuthorized._authority` is of type address.](#heading-6.3.7)
        * 6.3.8 - [`DSBalanceDB` return values](#heading-6.3.8)
        * 6.3.9 - [`DSApprovalDB` return values and status codes](#heading-6.3.9)
        * 6.3.10 - [`DSBasicAuthority.canCall` not marked as constant](#heading-6.3.10)
        * 6.3.11 - [`DSBasicAuthority.canCall` and `DSBasicAuthority.setCanCall` static return values](#heading-6.3.11)
        * 6.3.12 - [`DSBalanceDB.getSupply` and `DSBalanceDB.getBalance` return extra boolean status.](#heading-6.3.12)
        * 6.3.13 - [`DSBalanceDB.addBalance/subBalance/moveBalance` have unused named return values](#heading-6.3.13)
        * 6.3.14 - [`DSApprovalDB.set` and `DSApprovalDB.get` have constant boolean return value](#heading-6.3.14)
        * 6.3.15 - [`DSEphemeral`](#heading-6.3.15)
        * 6.3.16 - [`DSModifiers.contracts_only` and `DSModifiers.keys_only`](#heading-6.3.16)
        * 6.3.17 - [`DSMap` does not have existence checking.](#heading-6.3.17)
        * 6.3.18 - [`DSMap.get` not marked constant](#heading-6.3.18)
        * 6.3.19 - [`DSMap.get` and `DSMap.set` have unused named return values.](#heading-6.3.19)
        * 6.3.20 - [`DSMap.set` returns a constant boolean `true` value](#heading-6.3.20)
        * 6.3.21 - [`DSTokenBase.transfer` implicitly returns `false`](#heading-6.3.21)
        * 6.3.22 - [`DSTokenController.totalSupply` and `DSTokenController.balanceOf` and `DSTokenController.allowance` have unreachable `throw` statements](#heading-6.3.22)
        * 6.3.23 - [`DSTokenController.approve` has unreachable return statement](#heading-6.3.23)
        * 6.3.24 - [`DSTokenFrontend.eventCallback` is unnecessary](#heading-6.3.24)
        * 6.3.25 - [`DSEasyMultisig.confirm` action validation](#heading-6.3.25)
        * 6.3.26 - [`DSEasyMultisig.trigger` will always fail in certain conditions.](#heading-6.3.26)
    * 6.4 - [Medium Issues](#heading-6.4)
        * 6.4.1 - [Formal *freeze* mechanism for for database contracts.](#heading-6.4.1)
        * 6.4.2 - [Lack of inline comments](#heading-6.4.2)
        * 6.4.3 - [`DSAuthorized._auth_mode` is a boolean](#heading-6.4.3)
        * 6.4.4 - [`DSAuthorized.getAuthority` and `DSAuthorized.isAuthorized` unused named return values](#heading-6.4.4)
        * 6.4.5 - [`DSAuthorized.isAuthorized` has implicit return `false`](#heading-6.4.5)
        * 6.4.6 - [`DSStaticAuthorized`](#heading-6.4.6)
        * 6.4.7 - [`DSBasicAuthority.exportAuthorized` can be removed.](#heading-6.4.7)
        * 6.4.8 - [`DSBalanceDB` and `DSApprovalDB` ERC20 compliance](#heading-6.4.8)
    * 6.5 - [Major Issues](#heading-6.5)
        * 6.5.1 - [Token contracts have very low test coverage](#heading-6.5.1)
        * 6.5.2 - [dapple](#heading-6.5.2)
        * 6.5.3 - [`DSBasicAuthority` whitelist collision](#heading-6.5.3)
        * 6.5.4 - [`DSBasicAuthority` callee and caller variable names.](#heading-6.5.4)
        * 6.5.5 - [`DSBalanceDB` overflow protection](#heading-6.5.5)
        * 6.5.6 - [`DSApprovalDB` event logging](#heading-6.5.6)
        * 6.5.7 - [`DSTokenBase.transfer` and `DSTokenBase.transferFrom` do not perform overflow checking.](#heading-6.5.7)
        * 6.5.8 - [`DSTokenController.updateDBs` requires updating both database contracts.](#heading-6.5.8)
        * 6.5.9 - [`DSEthToken.withdraw` does not support withdrawal to contracts with fallback functions.](#heading-6.5.9)
        * 6.5.10 - [`DSEthToken.withdraw` does not implement underflow protection.](#heading-6.5.10)
        * 6.5.11 - [`DSEthToken.withdraw` does not allow full withdrawal](#heading-6.5.11)
        * 6.5.12 - [`DSEthToken._supply`](#heading-6.5.12)
        * 6.5.13 - [`DSEasyMultisig.confirm` always tries to execute the action](#heading-6.5.13)
        * 6.5.14 - [`DSEasyMultisig.confirm` does not validate `action_id`](#heading-6.5.14)
        * 6.5.15 - [`DSEasyMultisig.trigger` does not enforce gas value.](#heading-6.5.15)
        * 6.5.16 - [`DSEasyMultisig.trigger` does not enforce ether balance available](#heading-6.5.16)
    * 6.6 - [Critical Issues](#heading-6.6)
        * 6.6.1 - [`DSEasyMultisig.trigger` can be executed multiple times.](#heading-6.6.1)
        * 6.6.2 - [`DSEasyMultisig.trigger` marks the action as triggered after execution.](#heading-6.6.2)
        * 6.6.3 - [`DSEasyMultisig.trigger` is susceptible to stack depth based attacks.](#heading-6.6.3)
* 7 - [Follow up Deployer Audit](#heading-7)
    * 7.1 - [General Changes](#heading-7.1)
        * 7.1.1 - [More steps](#heading-7.1.1)
        * 7.1.2 - [Validating addresses are not `0x0`](#heading-7.1.2)
        * 7.1.3 - [More restrictive ACL](#heading-7.1.3)
        * 7.1.4 - [Single Multi-Signature contract](#heading-7.1.4)
    * 7.2 - [Issue Resolution](#heading-7.2)
        * 7.2.1 - [Factory and Deployment contract variables are not public](#heading-7.2.1)
        * 7.2.2 - [Deployer contracts `suicide`](#heading-7.2.2)
        * 7.2.3 - [`DSEasyMultisig` is unsafe to use](#heading-7.2.3)
        * 7.2.4 - [Token system and Principle of Least Privilege](#heading-7.2.4)
        * 7.2.5 - [Low test coverage](#heading-7.2.5)


# <a id="heading-2"/> Section 2 - Introduction

- From January 11th through January 26th of 2016, Piper Merriam via Quick Left
conducted an audit of the dappsys framework authored by Nexus.   The findings
of this audit are presented here in this document.


## <a id="heading-2.1"/> 2.1 Audit Goals

### <a id="heading-2.1.1"/> 2.1.1 Sound Architecture

The dappsys framework is comprised of many different contracts which are
composable to accomplish common needs of most DApps.

This audit evaluates the architecture of these systems through the lens of
established smart contract best practices and general software best practices.


### <a id="heading-2.1.2"/> 2.1.2 Code Correctness and Quality

This audit includes a full review of the contract source code.  The primary
areas of focus include:

* Correctness (does it do was it is supposed to do)
* Easy to read and/or understand
* Sections of code with high complexity.
* Antipatterns
* Adequate test coverage.


### <a id="heading-2.1.3"/> 2.1.3 Security

This audit focused on identifying security related issues within each system of
contracts.


### <a id="heading-2.1.4"/> 2.1.4 Phase 1 Deployer Contract

Audit the `MakerPhase1Deployer` contract which coordinates the deployment of
the first phase of the Maker public architecture.


## <a id="heading-2.2"/> 2.2 Source Code

The code being audited was from the **dappsys** repository under the
**NexusDevelopment** github account.

https://github.com/NexusDevelopment/dappsys
    
The state of the source code at the time of the audit can be found under the
commit sha `ac453dac08f71c214f3ab07b5f13d8cb8840c85b` which was tagged as
`0.2-audit-part3`.


### <a id="heading-2.2.1"/> 2.2.1 File List

The following source files were included in the audit.

* `actor/base.sol`
* `actor/base_actor.sol`
* `actor/base_actor_test.sol`
* `auth/auth.sol`
* `auth/auth_test.sol`
* `auth/authority.sol`
* `auth/authorized.sol`
* `auth/basic_authority.sol`
* `auth/basic_authority_test.sol`
* `data/balance_db.sol`
* `data/balance_db_test.sol`
* `data/approval_db.sol`
* `data/approval_db_test.sol`
* `data/map.sol`
* `util/ephemeral.sol`
* `util/modifiers.sol`
* `util/true.sol`
* `util/false.sol`
* `token/base.sol`
* `token/controller.sol`
* `token/deployer.sol`
* `token/erc20.sol`
* `token/eth_wrapper.sol`
* `token/frontend.sol`
* `token/token.sol`
* `gov/easy_multisig.sol`


The SHA256 of these files at the time of the audit was as follows:

```
$ shasum -a 256 src/sol/actor/base.sol src/sol/actor/base_actor.sol src/sol/actor/base_actor_test.sol src/sol/auth/auth.sol src/sol/auth/auth_test.sol src/sol/auth/authority.sol src/sol/auth/authorized.sol src/sol/auth/basic_authority.sol src/sol/auth/basic_authority_test.sol src/sol/data/balance_db.sol src/sol/data/balance_db_test.sol src/sol/data/approval_db.sol src/sol/data/approval_db_test.sol src/sol/data/map.sol src/sol/util/ephemeral.sol src/sol/util/modifiers.sol src/sol/util/true.sol src/sol/util/false.sol src/sol/token/base.sol src/sol/token/controller.sol src/sol/token/deployer.sol src/sol/token/erc20.sol src/sol/token/eth_wrapper.sol src/sol/token/frontend.sol src/sol/token/token.sol src/sol/gov/easy_multisig.sol
b9e45161750a5e414956059e11fe6d6927383c51e962ea69a5dae70a59d7138e  src/sol/actor/base.sol
b196d5ec8cd886b943e8c2debaab678aa0e1ef21907f589885530f4829c74a11  src/sol/actor/base_actor.sol
d5415a4eb0d70463dcc52a9f37e9075bd306ad85d7002beb9be66b605a6fac4d  src/sol/actor/base_actor_test.sol
15c9137633d25a77ecb4dd008d23bf5c74f4d8aaf6dfd8f75511993069694802  src/sol/auth/auth.sol
4e48fc13620ba5095ee8ec44afb09aeddf6a3fdd4c8de3d22b7e0267f2431938  src/sol/auth/auth_test.sol
af06df7f6520fd33bc438dafe9285c1d33877f926c07a8d44fc89c4c127fa201  src/sol/auth/authority.sol
58f1286e0d5766f343ad9dd9a78fcd22c6d0d6c727e3c4a540c12bd90e206f6d  src/sol/auth/authorized.sol
8a5df6f0da08ee8dac5dd06506425479faff82c7e524736084d09fc7cfd0b954  src/sol/auth/basic_authority.sol
0fca93f00ff5bb6c8bef200c8553c1042d9ad661549ebfba77771edaab068473  src/sol/auth/basic_authority_test.sol
8be0d38e8cbbaa657b3a575cfb626c35c89447e533f27b9e04ac433a28c65f7b  src/sol/data/balance_db.sol
1ed4b38130d69899739cc6309c1a7d46a4d7d35b660bc75045c53bae045c7831  src/sol/data/balance_db_test.sol
28211b4f6a944f05b753b1fe8f094b1998187c3c95a2f143c3e0385bd10f24ef  src/sol/data/approval_db.sol
f1967bb5ed5b89862339cf8f7e62db24aa99de5a064e04c7f04c40dddc744c99  src/sol/data/approval_db_test.sol
b1a21e6e70d88ebceb319e3236839215b9f305a57955b808017554a6def475ce  src/sol/data/map.sol
ff8552ff5687de3e9fe1bd742d1c06fcd6402619b300b15714a2e26388c57d97  src/sol/util/ephemeral.sol
73e27972c804e376eb47c01b1188a63d330e12a9f2c37f0e7c3238e63ec5d274  src/sol/util/modifiers.sol
112e0c014539bdc71d7c23bc74a2bb62c5a4645dcad3c8d89a6b4534ac6bfd5f  src/sol/util/true.sol
78afcda4a78c34d077bc6a60e724141b63cdcbba398b8a7727ba48faeeed7a75  src/sol/util/false.sol
2b46148959a2a52cd942e1f65b7bb5d4d7a5c839cb1641040a451ca20a30da6e  src/sol/token/base.sol
576925208469d3e7984419a4bfe1984fc0f787716735a7bd8de423eda7ebac67  src/sol/token/controller.sol
26e366b36b3243ecf7605c5e235a785f78584e0c4119b2410ae9721ca9d7c4bd  src/sol/token/deployer.sol
d7c89d851310469dd4de9f11b9f10e6c74934ab99c505cafbf9c9781059b0596  src/sol/token/erc20.sol
2e098a7fc9b59348bf6dc67beef698f6b0148a26cc4a5b24a5c092aff4e45085  src/sol/token/eth_wrapper.sol
2f9c8773e1fd3fcdb8677f03d861f230a47638fb44004e7e8d48175b0df944c4  src/sol/token/frontend.sol
2bf970399d41d48116ed7666201aab43b4b8002328ce1508f70fcae819dc9bf2  src/sol/token/token.sol
2c8bbeca09990a3cac183db88f5d673dd35f205d54ada8daf2306f5c5bc9398c  src/sol/gov/easy_multisig.sol
```


In addition to these source files, one additional source file which contains
the `MakerPhase1Deployer` contract was audited.


## <a id="heading-2.3"/> 2.3 Framework Components and Concepts

### <a id="heading-2.3.1"/> 2.3.1 Authority

An *Authority* in the dappsys Framework is an [Access Control
List](https://en.wikipedia.org/wiki/Access_control_list) or ACL system.  An
Authority contract implements a `canCall` function which takes the following
arguments.

* `caller`: The address which is executing the function call.
* `callee`: The address on which the function is being called.
* `sig`: The 4-byte signature of the function that is being called.

The Authority contract is used extensively across the majority of the contracts
to allow for fine grained control over which addresses are authorized to
execute each contract's functions.


* Primary Source Files:
    * `src/sol/auth/authority.sol`
    * `src/sol/auth/basic_authority.sol`
* Contracts
    * `DSAuthority`
    * `AcceptingAuthority`
    * `RejectingAuthority`
    * `DSBasicAuthority`


### <a id="heading-2.3.2"/> 2.3.2 Authorized

An Authorized contract is one which *subscribes* to an Authority contract for
all of its authorization checks.


* Primary Source Files:
    * `src/sol/auth/authorized.sol`
* Contracts
    * `DSAuthorized`
    * `DSStaticAuthorized`


### <a id="heading-2.3.3"/> 2.3.3 Databases

These contracts are used architecturally to keep the logic and data components
of contract systems separate.


* Primary Source Files:
    * `src/sol/data/balance_db.sol`
    * `src/sol/data/approval_db.sol`
    * `src/sol/data/map.sol`
* Contracts
    * `DSBalanceDB`
    * `DSApprovalDB`
    * `DSMap`


### <a id="heading-2.3.4"/> 2.3.4 Tokens (ERC20)

A system of contracts that implements the ERC20 interface standards.


* Primary Source Files:
    * `src/sol/token/frontend.sol`
    * `src/sol/token/controller.sol`
    * `src/sol/token/erc20.sol`
* Contracts
    * `DSTokenFrontend`
    * `DSTokenController`


### <a id="heading-2.3.5"/> 2.3.5 Actor

Actor contracts are proxy contracts which can *forward* function calls.


* Primary Source Files:
    * `src/sol/actor/base_actor.sol`
* Contracts
    * `DSBaseActor`


### <a id="heading-2.3.6"/> 2.3.6 Multisig Governance

A special form of Actor contract which uses a multi-signature mechanism to
democratically choose which actions the contract should execute.


* Primary Source Files:
    * `src/sol/gov/easy_multisig.sol`
* Contracts
    * `DSEasyMultisig`


### <a id="heading-2.3.7"/> 2.3.7 Factory Contracts

The majority of the dappsys contracts have a corresponding factory contract.
These factory contracts expose functions that will create a newly deployed
version of whatever contract the factory is setup to create based on the
provided function arguments.


### <a id="heading-2.3.8"/> 2.3.8 Deployer Contract

A deployer contract is one which manages the deployment of some system of
contracts, implementing any initial setup logic as solidity code.

The deployer pattern can allow for easier to verification of the setup of a
network of contracts that must be spread across multiple steps due to the
transaction gas limit.


## <a id="heading-2.4"/> 2.4 Quick Left and Piper Merriam

Quick Left is a web consultancy located in Boulder Colorado, USA.

I, Piper Merriam, am a full time Senior Engineer employed by Quick Left.  I
have been developing software as my full time profession since 2011.  Software
and technology however have always been a large part of my life.

I would present the following as evidence of my expertise in the appropriate
areas required to conduct this review.


### <a id="heading-2.4.1"/> 2.4.1 Open Source Work

* https://github.com/pipermerriam

My open source work can be found on my github account under the username
`pipermerriam`.  This work represents 5 years of software craftsmanship.

The following projects are recent ethereum related work.

* https://github.com/pipermerriam/ethereum-ipc-client
* https://github.com/pipermerriam/ethereum-rpc-client
* https://github.com/pipermerriam/ethereum-computation-market
* https://github.com/pipermerriam/ethereum-stack-depth-lib
* https://github.com/pipermerriam/ethereum-grove
* https://github.com/pipermerriam/ethereum-datetime
* https://github.com/pipermerriam/ethereum-cron
* https://github.com/pipermerriam/ethereum-string-utils


### <a id="heading-2.4.2"/> 2.4.2 Populus

* https://github.com/pipermerriam/populus

Populus is a development framework written in python for Ethereum contract
development and testing.  Creating this framework has required me to acquire an
intimate understanding of the internals of how contracts operate within the
Ethereum network.


### <a id="heading-2.4.3"/> 2.4.3 Ethereum Alarm Clock

* http://www.ethereum-alarm-clock.com/

The Ethereum Alarm Clock is the largest single piece of work that I have done
in the Ethereum space.


## <a id="heading-2.5"/> 2.5 Links

* ERC20 - https://github.com/ethereum/EIPs/issues/20
* Access Control List - https://en.wikipedia.org/wiki/Access_control_list
* Principle of Least Privilege - https://en.wikipedia.org/wiki/Principle_of_least_privilege


## <a id="heading-2.6"/> 2.6 Terminology

### <a id="heading-2.6.1"/> 2.6.1 Coverage

Measurement of the testing code coverage.  This measurement was done via
inspection of the code.

#### <a id="heading-2.6.1.1"/> 2.6.1.1 **untested**

No tests.


#### <a id="heading-2.6.1.2"/> 2.6.1.2 **low**

The tests do not cover some set of non-trivial functionality.


#### <a id="heading-2.6.1.3"/> 2.6.1.3 **good**

The tests cover all major functionality.


#### <a id="heading-2.6.1.4"/> 2.6.1.4 **excellent**

The tests cover all code paths.


### <a id="heading-2.6.2"/> 2.6.2 Severity

Measurement of magnitude of an issue..


#### <a id="heading-2.6.2.1"/> 2.6.2.1 **minor**

Minor issues are generally subjective in nature, or potentially deal with
topics like "best practices" or "readability".  Minor issues in general will
not indicate an actual problem or bug in code.

The maintainers should use their own judgement as to whether addressing these
issues improves the codebase.


#### <a id="heading-2.6.2.2"/> 2.6.2.2 **medium**

Medium issues are generally objective in nature but do not represent actual
bugs or security problems.

These issues should be addressed unless there is a clear reason not to.


#### <a id="heading-2.6.2.3"/> 2.6.2.3 **major**

Major issues will be things like bugs or security vulnerabilities.  These
issues may not be directly exploitable, or may require a certain condition to
arise in order to be exploited.

Left unaddressed these issues are highly likely to cause problems with the
operation of the contract or lead to a situation which allows the system to be
exploited in some way.


#### <a id="heading-2.6.2.4"/> 2.6.2.4 **critical**

Critical issues are directly exploitable bugs or security vulnerabilities.

Left unaddressed these issues are highly likely or guaranteed to cause major
problems or potentially a full failure in the operations of the contract.


# <a id="heading-3"/> Section 3 - Main Findings

## <a id="heading-3.1"/> 3.1 Primary Issues

### <a id="heading-3.1.1"/> 3.1.1 Static Return Values

* Severity: **minor**

There are many functions that implement boolean return values indicating
success or failure.  This pattern is often used in cases where there is no
failure mode, and thus the return value is effectively static.  This pattern
appears to be implemented as a form of future proofing given that many of these
contracts act as part of a larger system of contracts where individual
components may be replaced over time.

For example, the `DSApprovalDB.set` function currently implements one such
static return value, and the `DSTokenController.approve` function uses this
return value to determine whether it should fire the appropriate events for an
approval.  In the current state of this system of contracts there is no case
where the failure fork of this code is followed.  It can however be easily
forecasted that a new version of the `DSApprovalDB` might be created in which
the `set` function has conditions under which it will fail.

This example may seem like a compelling reason to leave these return values in
place, but it also is a direct violation of the widely accepted 
["You aren't going to need it"](https://en.wikipedia.org/wiki/You_aren't_gonna_need_it)
principle.

Within this system of contracts, both the `DSTokenController` and the
`DSApprovalDB` are able to be changed.  In the event that a future version of
the `DSApprovalDB.set` function implements a failure mode, then both the
`DSTokenController` and the `DSApprovalDB` can be updated.

As things stand, this system adds unnecessary complexity to an already complex
system.


### <a id="heading-3.1.2"/> 3.1.2 Database Contracts have no first class mechanism to freeze state

* Severity: **medium**

The token system is built from a network of 5 contracts.

* DSTokenFrontend
* DSTokenController
* DSBalanceDB
* DSApprovalDB
* DSAuthority

This network of contracts is designed to allow each individual component to be
changed out.

* Each contract inherits from `DSAuth` giving it an `updateAuthority` function
  for swapping out the relevant `DSAuthority` contract.
* `DSTokenController` has mechanisms for changing out both the
  `DSTokenFrontend`, `DSBalanceDB`, and `DSApprovalDB` contracts via the
  `setFrontend` and `updateDBs` functions.
* `DSTokenFrontend` implements `setController` for changing out its
  `DSTokenController` contract.

These mechanisms serve as a way to add features to the system as well as a way
to address bugs.

In the event that a bug was found in either database contract, the steps to
swap the contract would be similar to the following.

1. Remove the authorization for any entity to call any of the stateful
   functions on the relevant database contract.
2. Deploy updated database contract.
3. Migrate the database state to the new database contract.
4. Update the controller to point at the new database contract.
5. Enable authorization to call the new contract.

While these steps are effective at swapping out the defective contract, there
are problems that I believe could be easily addressed by implementing a formal
mechanism for locking the database contract's state.  The locking mechanism may
benefit from two types of locks, one which is reversible, and one which cannot
be reversed.

If the database contract can be formally locked, then in the event that the
database needs to be swapped out, once the database contract has been
permanently locked it removes the ability for any sort of side channel attack
where the balances are subtly manipulated during the migration to the new
contract.

While the use of the authentication for locking *can* achieve the goal of
having the database be immutable, the mechanism is harder to audit, and cannot
be done in a permanent manner since the authority contract always has access.

I recommend implementing a formal mechanism for freezing database states.


### <a id="heading-3.1.3"/> 3.1.3 Lack of inline comments

* Severity: **medium**

The project code does not have much in terms of comments beyond function and
contract level descriptions.  Much of the contract code would take less mental
effort to digest with inline documentation that explains the code's intention.

Consider this excerpt from `DSAuthorized`

```javascript
function isAuthorized() internal returns (bool is_authorized) {
    if( msg.sender == _authority ) {
        return true;
    }
    if( _auth_mode == true ) {
        var A = DSAuthority(_authority);
        return A.canCall( msg.sender, address(this), msg.sig );
    }    
}
```

Two small comments make the intent of this function clear without having to
fully digest the exact details of what the contract code does.

```javascript
function isAuthorized() internal returns (bool is_authorized) {
    // Whatever address is set as the `_authority` is always authorized.
    if( msg.sender == _authority ) {
        return true;
    }

    // Only do authorization check when `_auth_mode` is truthy.  Otherwise
    // authentication fails.
    if( _auth_mode == true ) {
        var A = DSAuthority(_authority);
        return A.canCall( msg.sender, address(this), msg.sig );
    }    
}
```


### <a id="heading-3.1.4"/> 3.1.4 Token contracts have very low test coverage

* Severity: **major**

The system of contracts that implements the ERC20 standard via a network of
contracts has minimal test coverage.  There is no coverage for any of the
functionality beyond the functions defined by ERC20.

This system of contracts implements a number of operations for swapping out the
individual components of the contract system.  These operations do not have any
test coverage despite being critical functionality.


### <a id="heading-3.1.5"/> 3.1.5 Events are not tested

* Severity: **minor**

The tests for this framework are written using dapple which uses solidity code
to test solidity contracts.  Because event (logging) data is not inspectable by
contracts themselves there is no test coverage for any of the events that are
emitted.

Recommend exploring how events can be tested or testing events using a
different framework.


### <a id="heading-3.1.6"/> 3.1.6 dapple

* Severity: **major**
* https://github.com/NexusDevelopment/dapple

All of the tests for this project are written using the dapple framework which
is also authored by Nexus. At the time of authoring this document, I was unable
to successfully install and run the test suite.

There are a few issues that may warrant concern related to reliance on the
dapple framework for testing.


#### <a id="heading-3.1.6.1"/> 3.1.6.1 Sparse Documentation

The project does not have much documentation beyond a basic README and links to
projects which use dapple.


#### <a id="heading-3.1.6.2"/> 3.1.6.2 No Apparent CI

The project does have a test suite which contains approximately 54 tests.  There
does not appear to be any form of continuous integration setup against this
project.


#### <a id="heading-3.1.6.3"/> 3.1.6.3 Solidity Based Tests

The dapple framework's testing facilities require tests to be written as
solidity contracts.  This imposes limitations to how well the following types
of things can be tested.

* Transactions which run out of gas
* Events (logging)
* Stack Depth based issues
* Exceptions


### <a id="heading-3.1.7"/> 3.1.7 Named vs Un-named return values

* Severity: **minor**

When declaring a function in solidity that returns a value, that value can
optionally be declared with a name.  This name can be excluded in favor of only
specifying the return type.

```javascript
contract MyContract {
    // declares a named return value `count`
    function getCount() returns (uint count) {
        ...
    }

    // only declares the return type.
    function getSize() returns (uint) {
        ...
    }
}
```

There are multiple locations in the contract source where a named return value
is declared but not used.  Here is one such example from the `DSApprovalDB`
contract.


```javascript
// src/sol/data/approval_db.sol

contract DSApprovalDB is DSAuth {
    ...
    function get( address holder, address spender )
             returns (uint amount, bool ok )
    {
        return (approvals[holder][spender], true);
    }
}
```

In this function, there are two named return values `amount` and `ok`.  These
names are helpful as they convey semantic meaning about what the return values
represent.  They are however also not used.  Another way to look at this
function's source code would be to think of un-used named return values as
un-used but instantiated local variables.


```javascript
contract DSApprovalDB is DSAuth {
    ...
    function get( address holder, address spender )
             returns (uint, bool)
    {
        uint amount;
        bool ok;
        return (approvals[holder][spender], true);
    }
}
```

This example is functionally equivalent to the original function.  This is
clearly worse since it removes any link between these variables and the
function's return values, but it does highlight the fact that the two variables
are not used.

A third option would be to make use of these variables.


```javascript
contract DSApprovalDB is DSAuth {
    ...
    function get( address holder, address spender )
             returns (uint, bool)
    {
        uint amount = approvals[holder][spender];
        bool ok = true;
        return (amount, ok);
    }
}
```

This code is easily converted back to using named return values.


```javascript
contract DSApprovalDB is DSAuth {
    ...
    function get( address holder, address spender )
             returns (uint amount, bool ok)
    {
        amount = approvals[holder][spender];
        ok = true;
        return (amount, ok);
    }
}
```

While this may seem a bit verbose, it has the following properties.

* Function signature conveys semantic meaning about its return values via their
  names.
* No declared but un-used variables.

This is a minor issue but may be worth checking if this pattern improves
readability in the cases where return values are named but not used.
Alternatively if the function's return statement is easy to comprehend,
consider removing the name from the return value.


## <a id="heading-3.2"/> 3.2 Test Coverage Analysis

Testing is implemented using the dapple framework which tests solidity
contracts using solidity code.


### <a id="heading-3.2.1"/> 3.2.1 DSBaseActor

* Coverage: **low**
* Test File: `src/sol/actor/base_actor_test.sol`

Recommend adding coverage for sending ether.

Recommend adding coverage for calls that specify gas.


### <a id="heading-3.2.2"/> 3.2.2 DSBasicAuthority

* Coverage: **low**
* Test File: `src/sol/auth/authority_test.sol`


#### <a id="heading-3.2.2.1"/> 3.2.2.1 Whitelist feature is not covered

The `DSBasicAuthority` contract implements a feature that allows an address to
be whitelisted to call any function on a contract by setting the function
signature `0x0000` to be `true`.  This feature does not have test coverage.

Recommend adding coverage for this feature.


### <a id="heading-3.2.3"/> 3.2.3 DSAuthorized

* Coverage: **low**
* Test File: `src/sol/auth/auth_test.sol`


#### <a id="heading-3.2.3.1"/> 3.2.3.1 Add precondition checks

The tests do not check the initial state of the Vault contract.  The intention
of many of these tests is to check whether an action did or did not cause a
change.  What they are actually testing is just that the `breached` value on
the contract ends in a specific state.

Recommend adding a *precondition* check to each test which expects the state of
`vault.breached()` to change.  This ensures that the contract did not somehow
begin in the desired end state.


#### <a id="heading-3.2.3.2"/> 3.2.3.2 `testNonOwnerCantBreach` has no assertions

The test case `testNonOwnerCantBreach` does not make any assertions.

Recommend adding the appropriate assertions to this test.


### <a id="heading-3.2.4"/> 3.2.4 DSStaticAuthorized

* Coverage: **untested**

Recommend adding coverage.


### <a id="heading-3.2.5"/> 3.2.5 DSBalanceDB

* Coverage: **low**
* Test File: `srt/sol/data/balance_db_test.sol`


#### <a id="heading-3.2.5.1"/> 3.2.5.1 No coverage for failure case of `moveBalance`

There is no coverage for the case where `moveBalance` fails due to insufficient
account balance.

Recommend adding coverage.


#### <a id="heading-3.2.5.2"/> 3.2.5.2 No coverage for tracking of overall supply

There are no assertions present to verify that the of the overall supply is
being accounted for correctly.

Recommend adding coverage.


#### <a id="heading-3.2.5.3"/> 3.2.5.3 `moveBalance` coverage does not check source account was debited

Test that covers balance transfers does not check that the source account was
correctly debited the amount transferred.

Recommend adding assertions for this.


### <a id="heading-3.2.6"/> 3.2.6 DSApprovalDB

* Coverage: **excellent**
* Test File: `src/sol/data/approval_db_test.sol`


### <a id="heading-3.2.7"/> 3.2.7 `DSModifiers`

* Coverage: **untested**

Recommend adding some coverage that these modifiers behave as expected.


### <a id="heading-3.2.8"/> 3.2.8 `DSEphemeral`

* Coverage: **untested**

Recommend adding basic coverage.


### <a id="heading-3.2.9"/> 3.2.9 `DSTrueFallback`

* Coverage: **untested**

Recommend adding basic coverage.


### <a id="heading-3.2.10"/> 3.2.10 `DSFalseFallback`

* Coverage: **untested**

Recommend adding basic coverage.


### <a id="heading-3.2.11"/> 3.2.11 `DSTokenBase`

* Coverage: **good**
* Test File: `src/sol/token/token_test.sol`


#### <a id="heading-3.2.11.1"/> 3.2.11.1 All coverage is implemented as a single test case

All of the test coverage for this contract is written as a single test case.
Understanding this test case requires mental overhead to track the expected
state as the test case progresses.

Recommend splitting this up into individual test cases.


### <a id="heading-3.2.12"/> 3.2.12 `DSTokenController`

* Coverage: **low**
* Test File: `src/sol/token/deployer_test.sol` via `src/sol/token/token_test.sol:TokenTester`


#### <a id="heading-3.2.12.1"/> 3.2.12.1 No coverage for frontend setter and getter

The `getFrontend` and `setFrontend` functions do not have any test
coverage.

Recommend adding coverage.


#### <a id="heading-3.2.12.2"/> 3.2.12.2 No coverage for database update

The `updateDBs` functionality does not have any test coverage.

Recommend adding coverage.


### <a id="heading-3.2.13"/> 3.2.13 `DSTokenFrontend`

* Coverage: **low**
* Test File: `src/sol/token/deployer_test.sol` via `src/sol/token/token_test.sol:TokenTester`


#### <a id="heading-3.2.13.1"/> 3.2.13.1 No coverage for controller getter and setter

The `getController` and `setController` functions do not have any test
coverage.

Recommend adding coverage.


### <a id="heading-3.2.14"/> 3.2.14 `EthToken`

* Coverage: **untested**

There is a test file at `src/sol/token/eth_wrapper_test.sol` but the test case
does not actually execute any tests against the `EthToken` contract.


### <a id="heading-3.2.15"/> 3.2.15 `DSTokenDeployer`

* Coverage: **low**


#### <a id="heading-3.2.15.1"/> 3.2.15.1 No coverage for non ERC20 functionality

This contract implements extra functions and events beyond the ERC20 standard.
These functions are not tested.

Recommend adding coverage since these contracts do much more.


## <a id="heading-3.3"/> 3.3 General Thoughts

The dappsys framework implements a diverse set of contracts which are highly
composable to accomplish a large number of common needs for decentralized
applications.  These contracts are kept small in that they generally do one
*thing* well.  This architecture choice instills a level of confidence in the
codebase since it should reduce the rate of certain classes of defects and bugs
since each component is simple and easy to understand.

The tradeoff to using numerous simple components is that systems built with
these contracts will incur complexity costs and require intimate knowledge of
their inner workings to administer correctly.  This tradeoff likely to be an
inherent requirement given the immutability of Ethereum contracts, and will
likely improve over time as tooling is created to reduce complexity through
good UX and abstraction layers.


### <a id="heading-3.3.1"/> 3.3.1 Authority System

The Authority system is an incredibly flexible ACL system which should allow
for fine grained authentication logic to be applied generically any contract.
It also represents the greatest security threat since it has unfettered
authority to call any of the functions on any of the contracts it controls.

It may be worth exploring what can be done to reduce the scope of this security
threat.  Some ideas that come to mind are:

* Formalized multi-sig authority (somewhat already in place via the
  `DSEasyMultisig` contract)
* Time delayed authority which institutes a time delay when access is granted.
  This should allow for mitigation procedures to be executed if a breach
  occurs.

Overall, the security concerns around this concept are not related to the
soundness of the system but to the fact that the security hinges on it being
managed correctly.


### <a id="heading-3.3.2"/> 3.3.2 Frontend/Controller/DB Pattern

This implementation of ERC20 strikes me as a powerful pattern for DAOs to
manage a token system.  The Frontent/Controller/DB pattern strikes me as
something that could be applied to other systems.  The current solution for
this seems to be the use of a *Resolver* contract which merely maintains a
reference to the current *live* address of the actual contract.  The *Frontend*
concept strikes me as a major improvement over the Resolver pattern, especially
for situations where the interface being implemented is well defined (as it is
in ERC20).


### <a id="heading-3.3.3"/> 3.3.3 Easy Multisignature Governance

This contract needs work.  The mechanism for triggering actions has multiple
layers of security flaws that must be addressed before this can be used in a
production environment.


### <a id="heading-3.3.4"/> 3.3.4 Testing and Coverage

I cannot recommend using these contracts for anything important until the test
coverage has been improved.  A significant portion of the functionality is not
covered by tests which would raise lots of warning flags if I were including
this system as a dependency in a system that handled fungible assets.

With regards to the specific use of `dapple` as a testing framework I have the
following opinions on the matter.  I think the framework shows promise but it
is too soon to know whether the idea of testing solidity with solidity code is
a good idea.  This approach also appears to restrict the ability to test things
like gas limits, stack depth attack surface, exceptions, and events/logging.
There may be ways to test these things with the `dapple` approach but my
current knowledge of the EVM and capabilities of solidity suggest they are not
trivial problems and are likely to have hidden complexities.

I think it may be responsible to explore either porting the test suite to a
more established framework, or to maintain a separate test suite to validate
that the `dapple` testing approach is on par with something like Embark or
Truffle which both have wide adoption.

Similarly, implementing a Continuous Integration solution such as Travis-CI or
Wercker which automate test runs for code merges can greatly reduce the
introduction of defects into the codebase.  This suggesting is intended for to
both **dappsys** and **dapple**.


### <a id="heading-3.3.5"/> 3.3.5 Deployer Pattern

The Deployer pattern seems to reduce some of the overhead required for
verifying a complex system of contracts as it removes the need to audit the
many transactions that would be required to do all of the post-deploy
configuration.


# <a id="heading-4"/> Section 4 - Detailed Findings

## <a id="heading-4.1"/> 4.1 Source File: `src/sol/actor/base_actor.sol`

### <a id="heading-4.1.1"/> 4.1.1 `DSSimpleActor` seems to be a contract specifically for testing

* Severity: **minor**

Recommend moving contract to a separate location away from `DSBaseActor` to
avoid incidental use in non-test based code.


### <a id="heading-4.1.2"/> 4.1.2 `DSBaseActor.exec` declares a named return value but does not use it

* Severity: **minor**

Recommend either making use of the named values or removing the named return
value in favor of only specifying the return type.


## <a id="heading-4.2"/> 4.2 Source File: `src/sol/auth/authorized.sol

### <a id="heading-4.2.1"/> 4.2.1 `DSAuthorized._authority` is not public

* Severity: **minor**

Recommend making this value `public`.  This will allow this value to be fetched
individually instead of requiring it be fetched via the `getAuthority`
function.


### <a id="heading-4.2.2"/> 4.2.2 `DSAuthorized._auth_mode` is not public

* Severity: **minor**

Recommend make this value `public`.  This will allow this value to be fetched
individually instead of requiring it be fetched via the `getAuthority`
function.


### <a id="heading-4.2.3"/> 4.2.3 `DSAuthorized._auth_mode` is a boolean

* Severity: **medium**

`DSAuthorized._auth_mode` is a boolean.  It's function is to specify the *mode*
that the contract's uses to authenticate function calls.  The boolean value
does not convey any semantic meaning of what `true` and `false` mean in terms
of how the contract will enforce authentication.

> "The authentication mode is *true*"

A new developer looking at this code would likely be required to actually look
at how the variable is used to understand what the meaning of `true` and
`false` values mean.

Recommend changing this to be an `enum` with descriptive names for each mode.

> "The authentication mode is set to `Modes.OnlyAuthority`"

A new developer who sees code that sets the mode to `Modes.OnlyAuthority` can
extract semantic meaning without having to see how the variable is used.


### <a id="heading-4.2.4"/> 4.2.4 `DSAuthorized.getAuthority` has unused named return value

* Severity: **minor**

The `getAuthority` function specifies two named return values but instead
merely returns the values from contract storage.

Recommend either making use of the named values or removing the named return
values in favor of only specifying the return types.


### <a id="heading-4.2.5"/> 4.2.5 `DSAuthorized.isAuthorized` has unused named return value

* Severity: **minor**

The `isAuthorized` function specifies a named return value `is_authorized` but
does not make use of the variable.

Recommend either making use of the named values or removing the named return
value in favor of only specifying the return type.


### <a id="heading-4.2.6"/> 4.2.6 `DSAuthorized.isAuthorized` implicitly returns false

* Severity: **medium**

The `isAuthorized` function has an implicit return value of `false`.  This
could be easily overlooked.

Recommend to change this function to have an explicit `return false;` statement
to make this behavior clear.


### <a id="heading-4.2.7"/> 4.2.7 `DSAuthorized._authority` is of type `address`

* Severity: **minor**

The value `_authority` is used in three primary locations within the contract.

* line 32: `if( msg.sender == _authority ) {`
* line 36 and 37:
    * `var A = DSAuthority(_authority);`
    * `return A.canCall( msg.sender, address(this), msg.sig );`
* line 50: `_authority = DSAuthority(new_authority);`

In all of these locations, if the type of `_authority` was set as `DSAuthority`
the code would still function the same.  This would allow for line 36 and 37 to
be condensed to a single statement.

* `return _authority.canCall( msg.sender, address(this), msg.sig );`

Recommend changing the contract change the type of `_authority` to be
`DSAuthority` rather than `address` to improve readability.


### <a id="heading-4.2.8"/> 4.2.8 `DSStaticAuthorized` could be eliminated

* Severity **medium**

The `DSStaticAuthorized` contract exists for cases where the entire address
space is required.  This contract does not implement the full `DSAuthorized`
API due to not being able to store any values locally as to preserve the full
address space.

Recommend making this contract implement the full API by storing the values in
a separate database contract similar to the following.

```javascript
contract DSStaticAuthorizedDB {
    mapping (address => address) public _authorities;

    function setAuthority(address _authority) public {
        _authorities[msg.sender] = _authority;
    }

    mapping (address => bool) public _modes;

    function setMode(bool _mode) public {
        _modes[msg.sender] = _mode;
    }
}
```

The DSStaticAuthorized contract could then be changed such that the
`static_auth` modifier delegates looking up the authority to the database
contract.

```javascript
contract DSStaticAuthorized {
    modifier static_auth( address _authorityDB ) {
        var db = DSStaticAuthorizedDB(_authorityDB);
        if( isAuthorized( db._authorities(address(this)) ) ) {
            _
        }
    }
}
```

This would allow `DSStaticAuthorized` to implement the `updateAuthority` method
without using up any of its own address space.


## <a id="heading-4.3"/> 4.3 Source File: `src/sol/auth/basic_authority.sol`

### <a id="heading-4.3.1"/> 4.3.1 `DSBasicAuthority.canCall` susceptible to collision

* Severity **major**

If someone is granted permission to call a function whose 4-byte signature is
`0x0000` they will also be granted permission to call every other function on
that contract.

Recommend implementing a secondary mechanism for storing the concept of being
whitelisted to call any function.


### <a id="heading-4.3.2"/> 4.3.2 `DSBasicAuthority.canCall` should use constant value in place of `0x0000`

* Severity: **minor**

```javascript
return _can_call[caller][callee][0x0000] == true
    || _can_call[caller][callee][sig];
```

Recommend replacing the `0x0000` value with a `constant`.


```javascript
bytes4 constant WHITELIST_ALL = 0x000`;

return _can_call[caller][callee][WHITELIST_ALL] == true
    || _can_call[caller][callee][sig];
```


### <a id="heading-4.3.3"/> 4.3.3 `DSBasicAuthority` caller and callee variable names are easy to transpose

* Severity: **major**

The variables `caller` and `callee` only differ by a single letter.  It would
be trivial to transpose these two values.  Such a transposition could have
significant consequences.

Recommend renaming them to names that are easy to distinguish such as
`caller_address/contract_address`.


### <a id="heading-4.3.4"/> 4.3.4 `DSBasicAuthority.canCall` is not marked as `constant`

* Severity: **minor**

The `canCall` function does not modify any state but is not marked as
`constant`

Recommend adding the `constant` keyword to this function definition.


### <a id="heading-4.3.5"/> 4.3.5 `DSBasicAuthority.canCall` always returns `true`

* Severity: **minor**

The `canCall` function always returns `true`.

Recommend removing this return value.


### <a id="heading-4.3.6"/> 4.3.6 `DSBasicAuthority.setCanCall` always returns `true`

* Severity: **minor**

The `setCanCall` function always returns `true`.

Recommend removing this return value.


### <a id="heading-4.3.7"/> 4.3.7 `DSBasicAuthority.exportAuthorized` can be removed

* Severity: **medium**

The functionality offered by the `exportAuthorized` is already in place through
the combination of the `updateAuthority` function and the `auth` modifier that
is applied to that function.

Recommend removing this function.


## <a id="heading-4.4"/> 4.4 Source File: `src/sol/data/balance_db.sol`

### <a id="heading-4.4.1"/> 4.4.1 `DSBalanceDB` does not conform to [ERC 20](https://github.com/ethereum/EIPs/issues/20)

* Severity: **medium**

The DSBalanceDB contract is a token contract but it does not conform to 
[ERC 20](https://github.com/ethereum/EIPs/issues/20).

Recommend to rename functions and events to conform to the Token Standards.
Diverging from the standard makes these contracts incompatible with any code
that works generically with tokens.


### <a id="heading-4.4.2"/> 4.4.2 `DSBalanceDB` overflow protection

* Severity: **major**

The overflow and underflow protection is inlined into the locations that do
addition and subtraction on account balances as well as to the overall supply.

Currently, the contract allows for situations to both overflow the `_supply`
value, as well as account balances.

* `address.addBalance(0xA, 2 ** 256 - 1)`
* `address.addBalance(0xB, 2 ** 256 - 1)`
* `address.moveBalance(0xA, 0xB, 1)`

At the end of these three operations both the `_supply` and balance of `0xB`
account would have overflowed.

Recommend moving this functionality to a utility function (examples below).

```javascript
function safeToAdd(uint a, uint b) returns (bool) {
    return (a + b < a);
}

function addSafely(uint a, uint b) returns (uint) {
    if (!safeToAdd(a, b)) throw;
    return a + b;
}

function safeToSubtract(uint a, uint b) returns (bool) {
    return (b <= a);
}

function subtractSafely(uint a, uint b) returns (uint) {
    if (!safeToSubtract(a, b)) throw;
    return a - b;
}
```

This ensures that all overflow and underflow protection is implemented using
the same mechanism and any modifications or bug fixes to this logic are
unilaterally applied.  This functionality should also be easier to test.

This type of functionality is ideal for libraries.


### <a id="heading-4.4.3"/> 4.4.3 `DSBalanceDB.getSupply` and `DSBalanceDB.getBalance` return extra boolean

* Severity: **minor**

Both the `getSupply` and `getBalance` functions return a second boolean
argument that is always `true`.

Recommend removing these return values.


### <a id="heading-4.4.4"/> 4.4.4 `DSBalanceDB.addBalance` declares a named return value but does not use it

* Severity: **minor**

Recommend either making use of the named values or removing the named return
value in favor of only specifying the return type.


### <a id="heading-4.4.5"/> 4.4.5 `DSBalanceDB.subBalance` declares a named return value but does not use it

* Severity: **minor**

Recommend either making use of the named values or removing the named return
value in favor of only specifying the return type.


### <a id="heading-4.4.6"/> 4.4.6 `DSBalanceDB.moveBalance` declares a named return value but does not use it

* Severity: **minor**

Recommend either making use of the named values or removing the named return
value in favor of only specifying the return type.


## <a id="heading-4.5"/> 4.5 Source File: `src/sol/data/approval_db.sol`

### <a id="heading-4.5.1"/> 4.5.1 `DSApprovalDB` does not conform to [ERC 20](https://github.com/ethereum/EIPs/issues/20)

* Severity: **medium**

This contract implements the same functionality as the `approve` and
`allowance` APIs from [ERC 20](https://github.com/ethereum/EIPs/issues/20)
under the function names `set` and `get`.

Recommend conforming to the ERC 20 specification.


### <a id="heading-4.5.2"/> 4.5.2 `DSApprovalDB.set` does not log any events on approvals

* Severity: **major**

No logging occurs when the `set` function is called.  This significantly
increases the difficulty in auditing this contract.  (ERC 20 calls this event
`Approval`)

Recommend logging and event for calls to `set`.

### <a id="heading-4.5.3"/> 4.5.3 `DSApprovalDB.set` returns constant boolean value

* Severity: **minor**

Calls to `set` will always return `true`

Recommend removing this return value.


### <a id="heading-4.5.4"/> 4.5.4 `DSApprovalDB.get` returns constant boolean value as second argument

* Severity: **minor**

Calls to `get` will always return `true` for the second argument.
 
Recommend removing this return value.


## <a id="heading-4.6"/> 4.6 Source File: `src/sol/util/ephemer.sol`

### <a id="heading-4.6.1"/> 4.6.1 `DSEphemeral` uses non-standard suicide function

* Severity: **minor**

The function that implements the suicide action for this contract is named
`cleanUp`.  Standard convention is to name this function `kill`.

Recommend renaming this function to `kill`.


### <a id="heading-4.6.2"/> 4.6.2 `DSEphemeral.cleanUp` can be called by anyone

* Severity: **major**

The `cleanUp` function is open to be called by anyone.  This opens up an attack
surface that may not be entirely clear to users. 

If the contract lives across multiple blocks it would be trivial for an
attacker to monitor newly minted contracts for the 4-byte signature of this
function and loot the contents of the contract.  Even for contracts that are
ephemeral within a single transaction (both created and destroyed in the same
transaction) if any function calls interact with external code there is a risk of having
the contract destroyed by an attacker.

Recommend adding ACL to this function to restrict when it can be killed.


### <a id="heading-4.6.3"/> 4.6.3 `DSModifiers.contracts_only` is trivial to circumvent

* Severity: **major**

This modifier provides zero protection and is trivial to circumvent. This could
lead to security holes due to the illusion of security.

Recommend removing this modifier.


### <a id="heading-4.6.4"/> 4.6.4 `DSModifiers.keys_only` is a potentially dangerous pattern

* Severity: **medium**

Considering the extensive conversations about the potential uses for proxy
contracts, this modifier discriminates against some very valid use cases for
proxying ethereum interactions through a proxy contract that forwards function
calls.

Recommend removing this modifier as to not encourage this pattern.


## <a id="heading-4.7"/> 4.7 Source File: `src/sol/data/map.sol`

### <a id="heading-4.7.1"/> 4.7.1 `DSMap` does not distinguish between unset and `0x0`

* Severity **minor**

The contract does not implement any mechanism for distinguishing between a key
being set to `0x0` and being unset.

Recommend exploring how this can be accomplished or providing a subclass of this
contract which supports this functionality.


### <a id="heading-4.7.2"/> 4.7.2 `DSMap.get` is not marked as `constant`

* Severity: **minor**

The `get` function does not modify any state but is not marked as
`constant`

Recommend adding the `constant` keyword to this function definition.


### <a id="heading-4.7.3"/> 4.7.3 `DSMap.get` declares a named return value but does not use it

* Severity: **minor**

Recommend either making use of the named values or removing the named return
value in favor of only specifying the return type.


### <a id="heading-4.7.4"/> 4.7.4 `DSMap.set` declares a named return value but does not use it

* Severity: **minor**

Recommend either making use of the named values or removing the named return
value in favor of only specifying the return type.


### <a id="heading-4.7.5"/> 4.7.5 `DSMap.set` always returns `true`

* Severity: **minor**

The `set` function always returns `true`.

Recommend removing this return value.


## <a id="heading-4.8"/> 4.8 Source File: `src/sol/token/base.sol`

### <a id="heading-4.8.1"/> 4.8.1 `DSTokenBase.transfer` has implicit return value of `false`

* Severity: **minor**

The function returns `false` implicitly if the sender has an insufficient
balance to execute the transfer.

Recommend adding an explicit `return false;` statement to make this behavior
clearer.


### <a id="heading-4.8.2"/> 4.8.2 `DSTokenBase.transfer` does not perform any overflow checking

* Severity: **major**

The `transfer` function does not perform any overflow checking when tokens are
added to the destination account.

Recommend adding overflow checking to this operation.


### <a id="heading-4.8.3"/> 4.8.3 `DSTokenBase.transferFrom` does not perform any overflow checking

* Severity: **major**

The `transferFrom` function does not perform any overflow checking when tokens
are added to the destination account.

Recommend adding overflow checking to this operation.


## <a id="heading-4.9"/> 4.9 Source File: `src/sol/token/controller.sol`

### <a id="heading-4.9.1"/> 4.9.1 `DSTokenController.totalSupply` has unreachable `throw` statement

* Severity: **minor**

The `totalSupply` checks the boolean return value from
`DSBalanceDB.getSupply()` and throws an exception if this value is `false`.
The `getSupply` function cannot return anything but `true` for this value
making this `throw` statement unreachable.

Recommend removing this code (as well as the static `true` return value from
`getSupply`)


### <a id="heading-4.9.2"/> 4.9.2 `DSTokenController.balanceOf` has unreachable `throw` statement

* Severity: **minor**

The `balanceOf` checks the boolean return value from `DSBalanceDB.getBalance()`
and throws an exception if this value is `false`.  The `getBalance` function
cannot return anything but `true` for this value making this `throw` statement
unreachable.

Recommend removing this code (as well as the static `true` return value from
`getBalance`)


### <a id="heading-4.9.3"/> 4.9.3 `DSTokenController.allowance` has unreachable `throw` statement

* Severity: **minor**

The `allowance` checks the boolean return value from `DSApprovalDB.get()`
and throws an exception if this value is `false`.  The `get` function
cannot return anything but `true` for this value making this `throw` statement
unreachable.

Recommend removing this code (as well as the static `true` return value from
`get`)


### <a id="heading-4.9.4"/> 4.9.4 `DSTokenController.approve` has unreachable `return false` statement

* Severity: **minor**

The `approve` function delegates to the `DSApprovalDB.set` function which
always returns `true`.  The return value of the `set()` call is then used to
determine whether the events should be fired.  Given that this value is always
`true` the following `return false;` statement cannot be reached.

Recommend removing this conditional (as well as the static `true` return value
from `DSApprovalDB.set`)


### <a id="heading-4.9.5"/> 4.9.5 `DSTokenController.updateDBs` updates both database contracts

* Severity: **major**

This function updates both the `DSApprovalDB` and `DSBalanceDB` contracts.

There will likely be cases where only one of these contracts needs to be
updated.

This implementation does not support granular authority to only allow updating
of one of these database contracts but not the other.

Recommend dividing this into two separate update functions, one for each
contract.


## <a id="heading-4.10"/> 4.10 Source File: `src/sol/token/frontend.sol`

### <a id="heading-4.10.1"/> 4.10.1 `DSTokenFrontend.eventCallback` is an unnecessary abstraction

* Severity: **minor**

The `eventCallback` function serves as a wrapper for emitting the appropriate
`Transfer` and `Approval` events.  The implementation requires that the caller
pass in an integer value which determines which event is emitted.

A developer reading code that uses the `eventCallback` function would need to
know about its implementation details to know what it does.

Recommend replacing `eventCallback` with two functions, one for each event.


### <a id="heading-4.10.2"/> 4.10.2 N/A

This section intentionally left empty to preserve heading numbering between
revisions.


### <a id="heading-4.10.3"/> 4.10.3 N/A

This section intentionally left empty to preserve heading numbering between
revisions.


### <a id="heading-4.10.4"/> 4.10.4 `src/sol/token/eth_wrapper.sol`

### <a id="heading-4.10.5"/> 4.10.5 `EthToken.withdraw` does not support withdrawal to addresses of other contracts with fallback functions

* Severity **major**

In the event that the entity that is withdrawing funds is a contract which
implements a fallback function, the sending of funds will always fail.
`address.send` provides minimal gas, and in the event that the address is a
contract with a fallback function the call will fail due to running out of gas.

Recommend implementing functionality to allow calls originating from another
contract to withdraw funds via something like `msg.sender.call.value(_value)()`


### <a id="heading-4.10.6"/> 4.10.6 `EthToken.withdraw` does not perform underflow protection

* Severity **major**

The deduction from the `_supply` amount does not implement any underflow
protection.

Recommend adding underflow protection to this operation.


### <a id="heading-4.10.7"/> 4.10.7 `EthToken.withdraw` does not allow full withdrawal of funds

* Severity **major**

The `withdraw` function checks whether the sender's balance is strictly
**greater than** the withdrawal amount, as opposed to checking that it is
**greater than or equal**.  This results in accounts not being able to withdraw
the last 1 wei from their accounts.

Recommend changing this to use the `>=` operator.


### <a id="heading-4.10.8"/> 4.10.8 `EthToken.withdraw` does not handle the failure of `address.send`

* Severity **major**

The `address.send` function can fail for a number of reasons.  If this fails
during a call to the `withdraw` function, the caller will lose the funds they
attempted to withdraw and the `_supply` value will drop below the actual ether
balance of the contract.

Recommend adding code to handle the case when sending the funds fails that
ensures the withdrawn value is not lost from both the `_balances` and `_supply`
records.


### <a id="heading-4.10.9"/> 4.10.9 `EthToken._supply` duplicates `this.balance`

* Severity: **medium**

The `_supply` variable in the contract should theoretically always be equal to
`this.balance`.

Recommend changing contract to use `this.balance` in all locations that it
currently uses the `_supply` variable.  `this.balance` is guaranteed to
always be an accurate reflection of the contract ether balance.


## <a id="heading-4.11"/> 4.11 `src/sol/gov/easy_multisig.sol`


### <a id="heading-4.11.1"/> 4.11.1 `DSEasyMultisig.confirm` always tries to execute the action

* Severity **major**

Let `G_1` be the amount of gas required to execute the `confirm` function up
until just before the `trigger` function.  Let `G_2` be the amount of gas
needed by the proposed action.  If `G_1 + G_2` is larger than the gas limit,
then the last confirmation will always result in an unsuccessful invocation of
the action.

Recommend removing the `trigger()` call from the `claim()` function and keeping
these two actions separate.


### <a id="heading-4.11.2"/> 4.11.2 `DSEasyMultisig.confirm` does not validate `action_id` parameter

* Severity **major**

The function does not validate that the provided `action_id` parameter is
associated with a valid action.  When called with an invalid `action_id` the
function will still register the confirmation as if it were interacting with a
valid action.  In the event that some number of future action id's accumulate
erroneous confirmations in this manner, an attacker could introduce a
controversial action when that action id is next.  This would allow this action
to be initialized with some number of confirmations already in place.  In the
event of a multisig contract which required confirmation from two of its three
members, this would allow a member to execute an action with only their vote.

Recommend validating that the provided `action_id` parameter corresponds with a
valid action.


### <a id="heading-4.11.3"/> 4.11.3 `DSEasyMultisig.confirm` can be called on expired actions

* Severity **minor**

The `confirm` function can still be called on actions whose expiration date has
passed.

Recommend validating that the expiration date has not passed.


### <a id="heading-4.11.4"/> 4.11.4 `DSEasyMultisig.confirm` can be called on actions that have already been triggered

* Severity **minor**

The `confirm` function can still be called after an action has been triggered.

Recommend restricting this function to only allow actions that have not already
been triggered.


### <a id="heading-4.11.5"/> 4.11.5 `DSEasyMultisig.trigger` can be executed multiple times

* Severity **critical**

The `trigger` function does not check whether the action has already been
triggered.  This allows actions which acquire enough confirmations to be
executed an unlimited number of times.

Recommend only allowing untriggered actions to be triggered.


### <a id="heading-4.11.6"/> 4.11.6 `DSEasyMultisig.trigger` marks the action as triggered after its execution

* Severity **critical**

The `trigger` function marks the action as triggered after it has been
executed.  This allows for the execution to perform a recursive call to the
`trigger` function allowing it to be executed multiple times within the same
call.

Recommend marking the action as triggered prior to executing the call.


### <a id="heading-4.11.7"/> 4.11.7 `DSEasyMultisig.trigger` is susceptible to stack depth attacks

* Severity **critical**

An attacker can execute this function with the stack depth artificially
increased in such a way that the execution of the action will always wail due
to the stack depth being too deep.  This will register as a successfully
triggered action even though the desired action failed.

Recommend adding a check to ensure that a sufficiently deep stack depth is
reachable prior to executing the action.

```javascript
contract DepthChecker {
    uint constant GAS_PER_DEPTH = 700;

    function checkDepth(uint n) constant returns (bool) {
        if (n == 0) return true;
        return address(this).call.gas(GAS_PER_DEPTH * n)(bytes4(sha3("__dig(uint256)")), n - 1);
    }

    function __dig(uint n) constant returns (bool) {
        if (n == 0) return true;
        if (!address(this).callcode(bytes4(sha3("__dig(uint256)")), n - 1)) throw;
    }
}
```

The solidity code above can be easily used to validate that the stack depth is
extendable to a specified depth.


### <a id="heading-4.11.8"/> 4.11.8 `DSEasyMultisig.trigger` will always fail in certain conditions

* Severity **minor**

In the case where the action is set to use all of the gas and the function
being called consumes all of the gas the `trigger` function will always fail
with an out of gas error when it hits the `exec` statement.

Recommend always keeping a reserve amount of gas when calling the `exec`
function such that the `trigger` function will always finish execution.


### <a id="heading-4.11.9"/> 4.11.9 `DSEasyMultisig` allows for actions that cannot be triggered within a certain gas limit

* Severity **minor**

Let `G_1` be the amount of gas necessary to execute the `trigger` function up
to but not including the call to `exec`.  If an action specifies a gas value of
at least `tx.gaslimit - G_1` and the executing function is implemented such
that it will consume all of the provided gas, then the `trigger` function will
never be able to successfully be called.

This is due to the fact that the `exec` will always pass through all of the
remaining gas.  When the underlying function throws an exception, the out of
gas error will propagate upwards reverting the entire call stack.

Recommend always keeping a reserve amount of gas when calling the `exec`
function such that the `trigger` function will always finish execution.


### <a id="heading-4.11.10"/> 4.11.10 `DSEasyMultisig.trigger` does not enforce the gas value

* Severity **major**

The `trigger` function does not validate that `msg.gas >= action.gas` prior to
execution.  An attacker can call this function with a gas value set to an
intentionally low value to force the `exec` call to fail.

As this function is currently written, this is not a problem since the
out-of-gas error will bubble up and revert the call to `trigger`.  However, if
the recommendation above is implemented to keep a reserve of gas to guarantee
that the `trigger` function always finishes, this attack becomes viable.

Recommend enforcing that `msg.gas >= action.gas`.  This should likely be
implemented such that `action.gas` cannot be set to an *impossible* value.


### <a id="heading-4.11.11"/> 4.11.11 `DSEasyMultisig.trigger` does not enforce the ether value

* Severity **minor**

The `trigger` function does not validate that the contract balance is
sufficient to cover the action's ether value.

Recommend validating the ether balance prior to allowing the action to be
triggered.


## <a id="heading-4.12"/> 4.12 `src/sol/token/deployer.sol`

### <a id="heading-4.12.1"/> 4.12.1 `DSTokenDeployer`

No issues.


# <a id="heading-5"/> Section 5 - Maker Phase 1 Deployer

The first set of contracts which control the on-chain Maker ecosystem are
deployed using the `MakerPhase1Deployer` contract.  The source code for this
contract is at the time of authoring this document in a private repository.

The SHA256 of the audited files is as follows.

```
$ shasum -a 256 contracts/deployers/phase1.sol contracts/deployers/phase1_test.sol
409e2074674e010975cfb4060632113f422471ef065f575f9be616484e212d09  contracts/deployers/phase1.sol
25f943e9f9e59873ddc0c900033a44d835c2e512aba7dc85f6b6593caa147acb  contracts/deployers/phase1_test.sol
```

See [Section 7](#heading-7) for the follow up review findings.

## <a id="heading-5.1"/> 5.1 `contracts/deployers/phase_1.sol`

This source file holds the `MakerPhase1Deployer` contract which executes the
following operations.


### <a id="heading-5.1.1"/> 5.1.1 Creation of Authority contract

Creation of a single `DSBasicAuthority` which will end up serving as the single
Authority for all `DSAuth` based contracts.


### <a id="heading-5.1.2"/> 5.1.2 Creation of multi-signature contract for administration.

Creation of a 2 of 3 `DSEasyMultisig` which acts as the Authority for the
`DSBasicAuthority` contract that.  This **admin** multisig holds the power to
do *any* operation on any of the contracts that are created during this phase.


### <a id="heading-5.1.3"/> 5.1.3 Creation of multi-signature contract for fund management.

Creation of a 2 of 2 `DSEasyMultisig` to manage the `DAI` fund.  This contract is
granted full permission to execute any operation on the database contract that
controls the `DAI` token supply.


### <a id="heading-5.1.4"/> 5.1.4 ERC20 Token System for `MKR` Token

Creates a system of token contracts (frontend/controller/databases) for the `MKR`
token. The balance is initialized at 1 million * 10^18 (1E24) tokens giving
each of the 1 million tokens the same divisibility precision as ether.

* Whitelisting of all function calls in both directions between the
  MKR-Frontend and MKR-Controller.
* Whitelisting of all function calls from the MKR-Controller to the
  MKR-BalanceDB and MKR-ApprovalDB database contracts.


### <a id="heading-5.1.5"/> 5.1.5 ERC20 Token System for `DAI` Token

Creates a system of token contracts (frontend/controller/databases) for the `DAI`
token.

9. Whitelisting of all function calls in both directions between the
   DAI-Frontend and DAI-Controller.
10. Whitelisting of all function calls from the DAI-Controller to the
    DAI-BalanceDB and DAI-ApprovalDB database contracts.
11. Whitelisting of all function calls from the 2 of 2 multisig contract to the
    DAI-BalanceDB contract.


### <a id="heading-5.1.6"/> 5.1.6 Token Registry

Sets up the **MakerTokenRegistry** and maps the `MKR` and `DAI` symbols to
their respective token frontend contract addresses.


## <a id="heading-5.2"/> 5.2 Deployment Analysis

### <a id="heading-5.2.1"/> 5.2.1 Constructor Arguments

The deployer contract is initialized with 5 addresses which represent the 3
addresses for the 2 of 3 admin multisig contract and the 2 addresses for the 2
of 2 fund management multisig contract.

It would improve the ease of auditing to create a subclass of this contract
with these addresses hard coded with the ones that will be used in production.
This can be simply done by creating a `ProductionMakerPhase1Deployer` contract which
hard codes these addresses in its constructor.

```javascript
contract ProductionMakerPhase1Deployer is MakerPhase1Deployer {
    function ProductionMakerPhase1Deployer MakerPhase1Deployer(0x1, 0x2, 0x3, 0x4, 0x5) {
    }
}
```

This makes verification of this contract as simple as verification of bytecode
and that all 5 steps have been executed.


### <a id="heading-5.2.2"/> 5.2.2 Steps

The deployment is spread across 5 steps.  Each step function uses a modifier to
enforce order of execution as well as each step being executed exactly once.


## <a id="heading-5.3"/> 5.3 Deployment Issues

### <a id="heading-5.3.1"/> 5.3.1 Variables are not marked as `public`

* Severity: **minor**

Marking these value as `public` makes this process easier to audit and verify.

Recommend adding the `public` modifier to each of the various contract
variables.


### <a id="heading-5.3.2"/> 5.3.2 `suicide` makes auditing more difficult.

* Severity: **medium**

At the end of the last step, the contract destroys itself.  This makes it more
difficult to audit the deployment history of the on-chain Maker assets.

Recommend removing the `suicide` call in favor of ensuring that the contract is
fully immutable once all steps have been completed.  This should also include
updating the contract's authority to the null address as to lock down the
`DSAuth` api.


### <a id="heading-5.3.3"/> 5.3.3 DSEasyMultisig is unsafe to use in its current state

* Severity: **critical**

There are issues with the `DSEasyMultisig` which are documented elsewhere in
this audit in detail which must be addressed prior to deployment of this
contract system.


### <a id="heading-5.3.4"/> 5.3.4 ACL rules between Frontend, Controller, and Database violate "Principle of least Privilege"

* Severity: **medium**

The authentication rules set up between the Token contracts are done by
whitelisting calls to any function as opposed to granting authorization on an
individual function level.  This for example gives the Frontend contract the
authority to call the `updateDBs` function on the controller.  This violates
the Principle of least Privilege which is a commonly accepted best practice in
security.

It is worth noting that the current implementations of these contracts do not
appear to create any exploitable vulnerabilities.

Recommend altering this portion of the deployment to grant only the necessary
permissions.


### <a id="heading-5.3.5"/> 5.3.5 Test coverage is low

* Severity: **major**

The test coverage for the deploy sequence is very low.

Recommend adding coverage for the following areas of functionality.

* Validate that steps will not execute out of order or multiple times.
* Validate contract state between steps.
* Validate 


# <a id="heading-6"/> Section 6 - Follow Up dappsys Audit

After the initial audit, a follow up audit was performed beginning on February
16th 2016 and concluding on February 18th 20016.  In this follow up audit, all
of the issues from sections 3-5 were reviewed against the updated codebase to
assess whether the issues had been adequately addressed.

This audit was performed on the codebase at commit sha
`4dceee5272b51744a89009907d5ca85a0a82faed`.

## <a id="heading-6.1"/> 6.1 Terminology

### <a id="heading-6.1.1"/> 6.1.1 Status: Resolved

Issues that are noted with the **resolved** status have been adequately
addressed.


### <a id="heading-6.1.2"/> 6.1.2 Status: Unchanged

Issues that are noted with the **unchanged** status have not been addressed.


### <a id="heading-6.1.3"/> 6.1.3 Status: Needs Work

Something was done in response to this issue but it does not fully address the
problem.


## <a id="heading-6.2"/> 6.2 Test Coverage

### <a id="heading-6.2.1"/> 6.2.1 `DSBaseActor` test coverage

* **Status:** resolved
* [Issue 3.2.1](#heading-3.2.1)

The test coverage for this contract has been expanded to cover more use cases.


### <a id="heading-6.2.2"/> 6.2.2 `DSBasicAuthority` test coverage

* **Status:** resolved
* [Issue 3.2.2](#heading-3.2.2)

The features that were not covered by tests have been removed.


### <a id="heading-6.2.3"/> 6.2.3 `DSAuthorized` test coverage

* **Status:** resolved
* [Issue 3.2.3](#heading-3.2.3)

Test coverage has been expanded.


### <a id="heading-6.2.4"/> 6.2.4 `DSStaticAuthorized` test coverage

* **Status:** resolved
* [Issue 3.2.4](#heading-3.2.4)

This contract was removed.


### <a id="heading-6.2.5"/> 6.2.5 `DSBalanceDB` test coverage

* **Status:** resolved
* [Issue 3.2.5](#heading-3.2.5)

The test coverage for the `DSBalanceDB` contract has increased and appears to
cover the full functionality of the contract.


### <a id="heading-6.2.6"/> 6.2.6 `DSModifiers` test coverage

* **Status:** resolved
* [Issue 3.2.7](#heading-3.2.7)

This contract was removed.


### <a id="heading-6.2.7"/> 6.2.7 `DSEphemeral` test coverage

* **Status:** resolved
* [Issue 3.2.8](#heading-3.2.8)

This contract was removed.


### <a id="heading-6.2.8"/> 6.2.8 `DSTrueFallback` and `DSFalseFallback` test coverage

* **Status:** resolved
* [Issue 3.2.9](#heading-3.2.9)
* [Issue 3.2.10](#heading-3.2.10)

Coverage was added for these two contracts.


### <a id="heading-6.2.9"/> 6.2.9 `DSTokenBase` test coverage

* **Status:** resolved
* [Issue 3.2.11](#heading-3.2.11)

The test coverage implemented via that `DSTokenTest` contract was split up
across multiple functions as suggested.


### <a id="heading-6.2.10"/> 6.2.10 `DSTokenController` and `DSTokenFrontend` test coverage

* **Status:** resolved
* [Issue 3.2.12](#heading-3.2.12)
* [Issue 3.2.13](#heading-3.2.13)

Test coverage has been added to improve coverage of the ERC20 based
functionality as well as add coverage for the controller/frontend specific
functionality.


### <a id="heading-6.2.11"/> 6.2.11 `DSEthToken` test coverage

* **Status:** resolved
* [Issue 3.2.14](#heading-3.2.14)

Test coverage was added for this contract for both the ERC20 functionality and
the withdraw/deposit specific functionality.


### <a id="heading-6.2.12"/> 6.2.12 `DSTokenDeployer` test coverage

* **Status:** resolved
* [Issue 3.2.15](#heading-3.2.15)

Coverage for the entire deployment suite has been added.


## <a id="heading-6.3"/> 6.3 Minor Issues


### <a id="heading-6.3.1"/> 6.3.1 Static Return Values

* **Status:** resolved
* [Issue 3.1.1](#heading-3.1.1)

The static return status codes were removed as suggested.


### <a id="heading-6.3.2"/> 6.3.2 dapple does not test events

* **Status:** resolved
* [Issue 3.1.5](#heading-3.1.5)

dapple now has facilities for testing events.


### <a id="heading-6.3.3"/> 6.3.3 Named vs Un-Named return values

* **Status:** resolved
* [Issue 3.1.7](#heading-3.1.7)


### <a id="heading-6.3.4"/> 6.3.4 `DSSimpleActor` is for testing.

* **Status:** resolved
* [Issue 4.1.1](#heading-4.1.1)

The contract was moved to a testing file.


### <a id="heading-6.3.5"/> 6.3.5 `DSBaseActor.exec` named return value.

* **Status:** resolved
* [Issue 4.1.2](#heading-4.1.2)

Return value removed in refactor.


### <a id="heading-6.3.6"/> 6.3.6 `DSAuthorized._authority` and `DSAuthority._auth_mode` are not public.

* **Status:** resolved
* [Issue 4.2.1](#heading-4.2.1)
* [Issue 4.2.2](#heading-4.2.2)

Both variables are now public.


### <a id="heading-6.3.7"/> 6.3.7 `DSAuthorized._authority` is of type address.

* **Status:** resolved
* [Issue 4.2.7](#heading-4.2.7)

This has been converted to be of type `DSAuthority`.


### <a id="heading-6.3.8"/> 6.3.8 `DSBalanceDB` return values

* **Status:** resolved
* [Issue 4.4.3](#heading-4.4.3)
* [Issue 4.4.4](#heading-4.4.4)
* [Issue 4.4.5](#heading-4.4.5)
* [Issue 4.4.6](#heading-4.4.6)

These issues were addressed.  Functions no longer use a `boolean` return status
or named return values that are not used in the function body.


### <a id="heading-6.3.9"/> 6.3.9 `DSApprovalDB` return values and status codes

* **Status:** resolved
* [Issue 4.5.3](#heading-4.5.3)
* [Issue 4.5.4](#heading-4.5.4)

These issues were addressed.  Functions no longer use a `boolean` return status
or named return values that are not used in the function body.


### <a id="heading-6.3.10"/> 6.3.10 `DSBasicAuthority.canCall` not marked as constant

* **Status:** resolved
* [Issue 4.3.4](#heading-4.3.4)

This function is now marked as `constant`


### <a id="heading-6.3.11"/> 6.3.11 `DSBasicAuthority.canCall` and `DSBasicAuthority.setCanCall` static return values

* **Status:** resolved
* [Issue 4.3.5](#heading-4.3.5)
* [Issue 4.3.6](#heading-4.3.6)

The static return values have been removed.


### <a id="heading-6.3.12"/> 6.3.12 `DSBalanceDB.getSupply` and `DSBalanceDB.getBalance` return extra boolean status.

* **Status:** resolved
* [Issue 4.4.3](#heading-4.4.3)

The extra boolean return value was removed.


### <a id="heading-6.3.13"/> 6.3.13 `DSBalanceDB.addBalance/subBalance/moveBalance` have unused named return values

* **Status:** resolved
* [Issue 4.4.4](#heading-4.4.4)
* [Issue 4.4.5](#heading-4.4.5)
* [Issue 4.4.6](#heading-4.4.6)

The unused named return values were removed.


### <a id="heading-6.3.14"/> 6.3.14 `DSApprovalDB.set` and `DSApprovalDB.get` have constant boolean return value

* **Status:** resolved
* [Issue 4.5.3](#heading-4.5.3)
* [Issue 4.5.4](#heading-4.5.4)

The return value has been removed.


### <a id="heading-6.3.15"/> 6.3.15 `DSEphemeral`

* **Status:** resolved
* [Issue 4.6.1](#heading-4.6.1)
* [Issue 4.6.2](#heading-4.6.2)

This contract has been removed.


### <a id="heading-6.3.16"/> 6.3.16 `DSModifiers.contracts_only` and `DSModifiers.keys_only`

* **Status:** resolved
* [Issue 4.6.3](#heading-4.6.3)
* [Issue 4.6.4](#heading-4.6.4)

These modifiers were removed.


### <a id="heading-6.3.17"/> 6.3.17 `DSMap` does not have existence checking. 

* **Status:** unchanged
* [Issue 4.7.1](#heading-4.7.1)

The suggested functionality was not implemented.


### <a id="heading-6.3.18"/> 6.3.18 `DSMap.get` not marked constant

* **Status:** resolved
* [Issue 4.7.2](#heading-4.7.2)

This function is now marked as `constant`.


### <a id="heading-6.3.19"/> 6.3.19 `DSMap.get` and `DSMap.set` have unused named return values.

* **Status:** unchanged
* [Issue 4.7.3](#heading-4.7.3)
* [Issue 4.7.4](#heading-4.7.4)

The named return values are still in place.  Per a conversation with Nikolai,
this was an intentional choice to improve readability.


### <a id="heading-6.3.20"/> 6.3.20 `DSMap.set` returns a constant boolean `true` value

* **Status:** resolved
* [Issue 4.7.5](#heading-4.7.5)

This function no longer returns a boolean.


### <a id="heading-6.3.21"/> 6.3.21 `DSTokenBase.transfer` implicitly returns `false`

* **Status:** resolved
* [Issue 4.8.1](#heading-4.8.1)

The transfer function is now implemented such that it has an explicit return
statement.


### <a id="heading-6.3.22"/> 6.3.22 `DSTokenController.totalSupply` and `DSTokenController.balanceOf` and `DSTokenController.allowance` have unreachable `throw` statements

* **Status:** resolved
* [Issue 4.9.1](#heading-4.9.1)
* [Issue 4.9.2](#heading-4.9.2)
* [Issue 4.9.3](#heading-4.9.3)

These functions now just delegate to the equivalent database contract methods.


### <a id="heading-6.3.23"/> 6.3.23 `DSTokenController.approve` has unreachable return statement

* **Status:** resolved
* [Issue 4.9.4](#heading-4.9.4)

This function now just delegates to the equivalent database function.


### <a id="heading-6.3.24"/> 6.3.24 `DSTokenFrontend.eventCallback` is unnecessary

* **Status:** resolved
* [Issue 4.10.1](#heading-4.10.1)

This function was removed in favor of the two functions `emitApproval` and
`emitTransfer`.


### <a id="heading-6.3.25"/> 6.3.25 `DSEasyMultisig.confirm` action validation

* **Status:** resolved
* [Issue 4.11.3](#heading-4.11.3)
* [Issue 4.11.4](#heading-4.11.4)

This function now checks that the action has not expired, or been triggered.


### <a id="heading-6.3.26"/> 6.3.26 `DSEasyMultisig.trigger` will always fail in certain conditions.

* **Status:** unchanged
* [Issue 4.11.8](#heading-4.11.8)
* [Issue 4.11.9](#heading-4.11.9)

This has not been fixed.  An action which calls a function which always fails
(such as an infinite loop) will propagate the exception upwards making the
action un-executable.

Based on a conversation with Nikolai, this was an intentional design decision
so that actions either succeed or expire, but cannot be in a triggered but
failed state.


## <a id="heading-6.4"/> 6.4 Medium Issues

### <a id="heading-6.4.1"/> 6.4.1 Formal *freeze* mechanism for for database contracts.

* **Status:** unchanged
* [Issue 3.1.2](#heading-3.1.2)

This suggestion was not implemented.


### <a id="heading-6.4.2"/> 6.4.2 Lack of inline comments

* **Status:** resolved
* [Issue 3.1.3](#heading-3.1.3)

The codebase has improved in this regard.


### <a id="heading-6.4.3"/> 6.4.3 `DSAuthorized._auth_mode` is a boolean

* **Status:** resolved
* [Issue 4.2.3](#heading-4.2.3)

This value has been converted to an Enum as suggested.


### <a id="heading-6.4.4"/> 6.4.4 `DSAuthorized.getAuthority` and `DSAuthorized.isAuthorized` unused named return values

* **Status:** unchanged
* [Issue 4.2.4](#heading-4.2.4)
* [Issue 4.2.5](#heading-4.2.5)

The named return values were kept in place.  Based on a conversation with
Nikolai, this was done for the sake of readability.


### <a id="heading-6.4.5"/> 6.4.5 `DSAuthorized.isAuthorized` has implicit return `false`

* **Status:** resolved
* [Issue 4.2.6](#heading-4.2.6)

This function no longer has any implicit returns.


### <a id="heading-6.4.6"/> 6.4.6 `DSStaticAuthorized`

* **Status:** resolved
* [Issue 4.2.8](#heading-4.2.8)

This contract was removed.


### <a id="heading-6.4.7"/> 6.4.7 `DSBasicAuthority.exportAuthorized` can be removed.

* **Status:** resolved
* [Issue 4.3.7](#heading-4.3.7)

This function was removed.


### <a id="heading-6.4.8"/> 6.4.8 `DSBalanceDB` and `DSApprovalDB` ERC20 compliance

* **Status:** resolved
* [Issue 4.4.1](#heading-4.4.1)
* [Issue 4.5.1](#heading-4.5.1)

This was not addressed.  I no longer think that conformity to ERC20 would
improve this contract now that I have a deeper understanding of how it is used.


## <a id="heading-6.5"/> 6.5 Major Issues

### <a id="heading-6.5.1"/> 6.5.1 Token contracts have very low test coverage

* **Status:** resolved
* [Issue 3.1.4](#heading-3.1.4)

The overall level of test coverage on the codebase has improved.


### <a id="heading-6.5.2"/> 6.5.2 dapple

* **Status:** improved
* [Issue 3.1.6](#heading-3.1.6)

The dapple project has since set up continuous integration testing via travis-ci
and added facilities for testing events.

I was also able to install and execute the test suite for dappsys locally.  It
succeeded with 111 passing tests.

The project is still very sparse in terms of documentation. 


### <a id="heading-6.5.3"/> 6.5.3 `DSBasicAuthority` whitelist collision

* **Status:** resolved
* [Issue 4.3.1](#heading-4.3.1)
* [Issue 4.3.2](#heading-4.3.2)

The global whitelist functionality was removed which eliminated the collision
problem.


### <a id="heading-6.5.4"/> 6.5.4 `DSBasicAuthority` callee and caller variable names.

* **Status:** resolved
* [Issue 4.3.3](#heading-4.3.3)

The `caller` and `callee` variables were renamed to `caller_address` and
`code_address` respectively.


### <a id="heading-6.5.5"/> 6.5.5 `DSBalanceDB` overflow protection

* **Status:** resolved
* [Issue 4.4.2](#heading-4.4.2)

All addition and subtraction operations are handled using a helper function
from the `DSSafeAddSub` contract which does appropriate overflow and underflow
protection.



### <a id="heading-6.5.6"/> 6.5.6 `DSApprovalDB` event logging

* **Status:** resolved
* [Issue 4.5.2](#heading-4.5.2)

This contract now logs the ERC20 `Approval` event on approvals.


### <a id="heading-6.5.7"/> 6.5.7 `DSTokenBase.transfer` and `DSTokenBase.transferFrom` do not perform overflow checking.

* **Status:** resolved
* [Issue 4.8.2](#heading-4.8.2)
* [Issue 4.8.3](#heading-4.8.3)

Overflow checking has been implemented on these two functions.


### <a id="heading-6.5.8"/> 6.5.8 `DSTokenController.updateDBs` requires updating both database contracts.

* **Status:** resolved
* [Issue 4.9.5](#heading-4.9.5)

This function has been split out into the two functions `setBalanceDB` and
`setApprovalDB`.


### <a id="heading-6.5.9"/> 6.5.9 `DSEthToken.withdraw` does not support withdrawal to contracts with fallback functions.

* **Status:** resolved
* [Issue 4.10.5](#heading-4.10.5)
* [Issue 4.10.8](#heading-4.10.8)

This function now sends funds in a way that is compatible with contracts with
fallback functions.


### <a id="heading-6.5.10"/> 6.5.10 `DSEthToken.withdraw` does not implement underflow protection.

* **Status:** resolved
* [Issue 4.10.6](#heading-4.10.6)

This is no longer an issue now that the contract uses `this.balance` to
determine the supply.


### <a id="heading-6.5.11"/> 6.5.11 `DSEthToken.withdraw` does not allow full withdrawal

* **Status:** resolved
* [Issue 4.10.7](#heading-4.10.7)

This function now uses the appropriate `>=` operator.


### <a id="heading-6.5.12"/> 6.5.12 `DSEthToken._supply`

* **Status:** resolved
* [Issue 4.10.9](#heading-4.10.9)

This contract now uses `this.balance` instead of doing supply tracking.


### <a id="heading-6.5.13"/> 6.5.13 `DSEasyMultisig.confirm` always tries to execute the action

* **Status:** resolved
* [Issue 4.11.1](#heading-4.11.1)

This function no longer tries to trigger the action.


### <a id="heading-6.5.14"/> 6.5.14 `DSEasyMultisig.confirm` does not validate `action_id`

* **Status:** needs work
* [Issue 4.11.2](#heading-4.11.2)

The function will still allow an action_id value of `0`


### <a id="heading-6.5.15"/> 6.5.15 `DSEasyMultisig.trigger` does not enforce gas value.

* **Status:** resolved
* [Issue 4.11.10](#heading-4.11.10)

This is no longer an issue since the `gas` value has been removed from the
underlying `exec` function.


### <a id="heading-6.5.16"/> 6.5.16 `DSEasyMultisig.trigger` does not enforce ether balance available

* **Status:** resolved
* [Issue 4.11.11](#heading-4.11.11)

The function now checks that it has a sufficient balance prior to executing the
action.


## <a id="heading-6.6"/> 6.6 Critical Issues

### <a id="heading-6.6.1"/> 6.6.1 `DSEasyMultisig.trigger` can be executed multiple times.


* **Status:** resolved
* [Issue 4.11.5](#heading-4.11.5)

This function now checks that the action has not yet been triggered.


### <a id="heading-6.6.2"/> 6.6.2 `DSEasyMultisig.trigger` marks the action as triggered after execution.

* **Status:** resolved
* [Issue 4.11.6](#heading-4.11.6)

This issue has been resolved.


### <a id="heading-6.6.3"/> 6.6.3 `DSEasyMultisig.trigger` is susceptible to stack depth based attacks.

* **Status:** resolved
* [Issue 4.11.7](#heading-4.11.7)

This has been addressed via a fix to `DSBaseActor` which throws an exception if
the underlying function call fails.

It is worth noting that stack depth based attacks could still be used to cause
certain types of underlying failures such as sending ether.  For example, if
the function call was targeted at the `withdraw` function below.

```javascript
contract Bank {
    function withdraw(uint value) {
        ... # balance checking and business logic.
        msg.sender.send(value);
    }
}
```

In this example, an attacker *could* trigger the action such that it
successfully executed but did not actually send the funds.  This would be done
by ensuring that at the point that the EVM entered the `withdraw` function that
it was at the maximum allowed stack depth.

It is worth noting that this `Bank` contract is poorly written in that it does
not check the return value of the `send(..)` call, so it *could* be argued that
it is not the responsibiliy of `DSEasyMultisig` to protect against this
failure.

I don't believe this issue is fully resolved, but in the current state, I would
classify it as a **minor** issue.


# <a id="heading-7"/> Section 7 - Follow up Deployer Audit

After addressing the issues found in the audit, these files were reviewed again
at commit sha `761b06a3518327fe0de9877a571c85ad5925e112`.  The SHA256 of the
updated files is as follows.

```
$ shasum -a 256 contracts/deployers/phase1.sol contracts/deployers/phase1_test.sol
6647507d08d96ea2b3cf75538d3066189bdb96c0d3ac57b86cd88aa311acef43  contracts/deployers/phase1.sol
2854c8f52cab8ef31f20913a2aa2398e317e69cec90c53dc0c56e574d7fa9767  contracts/deployers/phase1_test.sol
```

## <a id="heading-7.1"/> 7.1 General Changes


### <a id="heading-7.1.1"/> 7.1.1 More steps

The deployment is now split across 8 steps (previously 5).


### <a id="heading-7.1.2"/> 7.1.2 Validating addresses are not `0x0`

The deployer now verifies after each factory build that the returned contract
addresses are not `0x0`.


### <a id="heading-7.1.3"/> 7.1.3 More restrictive ACL

The access control logic is more restrictive.  There are no more globally
whitelisted function calls setup between the various contracts.


### <a id="heading-7.1.4"/> 7.1.4 Single Multi-Signature contract

There is now a single multisignature contract which requires 4 of 6 signatures
and 24 hours of debate.  This seems like an improvement from the previous
version which had two separate multi-sig contracts running separate portions of
the contracts. 


## <a id="heading-7.2"/> 7.2 Issue Resolution

### <a id="heading-7.2.1"/> 7.2.1 Factory and Deployment contract variables are not public

* **Status:** resolved
* [Issue 5.3.1](#heading-5.3.1)

These variables are now marked as public.


### <a id="heading-7.2.2"/> 7.2.2 Deployer contracts `suicide`

* **Status:** resolved
* [Issue 5.3.2](#heading-5.3.2)

These contracts no longer `suicide` upon completion.


### <a id="heading-7.2.3"/> 7.2.3 `DSEasyMultisig` is unsafe to use

* **Status:** resolved
* [Issue 5.3.3](#heading-5.3.3)

All of the issues found within this contract have been resolved.


### <a id="heading-7.2.4"/> 7.2.4 Token system and Principle of Least Privilege


* **Status:** resolved
* [Issue 5.3.4](#heading-5.3.4)

The deployment of these contracts now explicitly whitelists the function calls
that are allowed between the two contracts.


### <a id="heading-7.2.5"/> 7.2.5 Low test coverage

* **Status:** resolved
* [Issue 5.3.5](#heading-5.3.5)

The test coverage has been expanded significantly across the application.  It
appears that all major functionality has been covered.

