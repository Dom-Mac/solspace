# 🚧 WORK IN PROGRESS 🚧

# Security research

This repo aims to cover the most common security vulnerabilities in EVM smart contracts,
and provides a set of tools to help developers to find and fix them.
Vulnerabilities are categorized by their type, each type has an example of a vulnerable contract,
a fixed contract (proof) and an exploit to verify the vulnerability.

## ReEntrancy Attack

[Git Source](https://github.com/Dom-Mac/solspace/blob/f5838bdc64c22456cef26721eb6148f05fc8f839/src/ReEntrancy)

A re-entrancy attack can happen when the **Checks-Effects-Interactions** pattern is not
respected during contracts development.

- **Check**: Validate parameters before modifying the state

- **Effects**: Change the state

- **Interactions**: Call other contracts after storage has been updated accordingly

Every time an interaction is made, the cycle starts again.

### Vulnerable withdraw

[Git Source](https://github.com/Dom-Mac/solspace/blob/f5838bdc64c22456cef26721eb6148f05fc8f839/src/ReEntrancy/ReEntrancyVulnerable.sol)

```solidity
    /**
     * @dev Function to withdraw your deposited funds **vulnerable**
     */
    function withdraw() public {
        /**
         * @dev The interaction is made BEFORE the state's update
         *      **wrong**
         */
        (bool success, ) = msg.sender.call{value: balances[msg.sender]}("");

        /**
         * @dev Update the state
         *      **wrong**
         */
        if (success) balances[msg.sender] = 0;
    }
```

### Fixed withdraw

[Git Source](

## Installation

```bash
forge install
forge test
```
