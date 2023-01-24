// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {ReEntrancyVulnerable} from "../src/ReEntrancy/ReEntrancyVulnerable.sol";
import {ReEntrancyProof} from "../src/ReEntrancy/ReEntrancyProof.sol";
import {ReEntrancyExploit} from "../src/ReEntrancy/ReEntrancyExploit.sol";

/**
 * @title Re-entrancy Test
 * @author Dom-Mac
 * @notice A deposit of 1 ether allows to exploit over 100 times
 *         Increasing the deposit amount will decrease the number of re-entrancy
 *         calls to the vulnerable contract before it is drained.
 *         This limits the amount of gas that can be used to drain the contract,
 *         avoing stack too deep errors and out of gas errors.
 * @notice The proof contract is not exploitable.
 */
contract ReEntrancyTest is Test {
    ReEntrancyVulnerable public vulnerable;
    ReEntrancyProof public proof;
    ReEntrancyExploit public exploitVulnerable;
    ReEntrancyExploit public exploitProof;

    uint256 public amount = 100 ether;
    uint256 public amountToDeposit = 1 ether;

    function setUp() public {
        vulnerable = new ReEntrancyVulnerable();
        proof = new ReEntrancyProof();
        exploitVulnerable = new ReEntrancyExploit(address(vulnerable));
        exploitProof = new ReEntrancyExploit(address(proof));

        // send amount to the vulnerable contract
        vm.deal(address(vulnerable), amount);
        // send amount to the proof contract
        vm.deal(address(proof), amount);
    }

    function testDeploy() public {
        assertTrue(address(vulnerable) != address(0));
        assertTrue(address(proof) != address(0));
        assertTrue(address(exploitVulnerable) != address(0));
    }

    function testExploitOnVulnerable() public {
        // check that the vulnerable contract has amount
        assertEq(address(vulnerable).balance, amount);

        // call the exploit function
        exploitVulnerable.exploit{value: 1 ether}();

        // check that the exploit contract has 0 ether
        assertEq(address(vulnerable).balance, 0);
    }

    function testExploitOnProof() public {
        // check that the vulnerable contract has amount
        assertEq(address(proof).balance, amount);

        // call the exploit function
        exploitProof.exploit{value: amountToDeposit}();

        // check that the exploit contract has amount
        assertEq(address(proof).balance, amount);
    }
}
