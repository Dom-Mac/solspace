# ReEntrancyVulnerable
[Git Source](https://github.com/Dom-Mac/solspace/blob/fae5ae58a261d6171732e7e3fc202c6db451a6a1/src/ReEntrancy/ReEntrancyVulnerable.sol)

**Inherits:**
[ReEntrancyInterface](/src/ReEntrancy/Interfaces/ReEntrancyInterface.sol/contract.ReEntrancyInterface.md)

**Author:**
Dom-Mac <dom@dommac.dev>

A re-entrancy attack can happen when the
Checks-Effects-Interactions pattern is not
respected during contracts dev.
Check:        Validate parameters before
modifying the state
Effects:      Change the state
Interactions: Call other contracts after
storage has been updated
accordingly

DO NOT USE - vulnerable contract


## State Variables
### balances
*Mapping of token holders and amounts*


```solidity
mapping(address => uint256) public balances;
```


## Functions
### withdraw

*Function to withdraw your holds **vulnerable***


```solidity
function withdraw() public;
```

### deposit

*The interaction is made BEFORE the state's update
wrong***

*Update the state
wrong***

*Function to deposit funds*


```solidity
function deposit() public payable;
```

