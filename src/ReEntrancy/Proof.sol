// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ReEntrancyInterface} from "./Interfaces/ReEntrancyInterface.sol";

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
 *
 * @notice This contract is free from re-entrancy attacks
 */
contract ReEntrancyProof is ReEntrancyInterface {
    /**
     * @dev Mapping of token holders and amounts
     */
    mapping(address => uint256) public balances;

    /**
     * @dev Function to withdraw your holds
     */
    function withdraw() public {
        uint256 amount = balances[msg.sender];

        /**
         * @dev Update the state before interaction
         */
        balances[msg.sender] = 0;

        /**
         * @dev The external interaction is made AFTER the state's update
         */
        (bool success, ) = msg.sender.call{value: amount}("");

        /**
         * @dev Check if the interaction was successful
         */
        require(success, "Withdrawal failed");
    }

    /**
     * @dev Function to deposit funds
     */
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
}
