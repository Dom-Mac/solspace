// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ReEntrancyInterface} from './Interfaces/ReEntrancyInterface.sol';

/**
 * @title Re-entrancy
 * @author Dom-Mac <dom@dommac.dev>
 *
 * @notice A re-entrancy attack can happen when the
 *         Checks-Effects-Interactions pattern is not
 *         respected during contracts dev.
 *
 *         Check:        Validate parameters before
 *                       modifying the state
 *
 *         Effects:      Change the state
 *
 *         Interactions: Call other contracts after
 *                       storage has been updated
 *                       accordingly
 */

/**
 * @notice DO NOT USE - vulnerable contract
 */
contract ReEntrancyVulnerable is ReEntrancyInterface {
  /**
   * @dev Mapping of token holders and amounts
   */
  mapping(address => uint256) public balances;

  /**
   * @dev Function to withdraw your deposited funds **vulnerable**
   */
  function withdraw() public {
    /**
     * @dev The interaction is made BEFORE the state update
     *      **wrong**
     */
    (bool success, ) = msg.sender.call{value: balances[msg.sender]}('');

    /**
     * @dev Update the state
     *      **wrong**
     */
    if (success) balances[msg.sender] = 0;
  }

  /**
   * @dev Function to deposit funds
   */
  function deposit() public payable {
    balances[msg.sender] += msg.value;
  }
}
