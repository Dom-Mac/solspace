// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {ReEntrancyVulnerable, ReEntrancyProof, ReEntrancyExploit} from "../src/ReEntrancy.sol";

contract ReEntrancyTest is Test {
    ReEntrancyVulnerable public vulnerable;
    ReEntrancyProof public proof;
    ReEntrancyExploit public exploitVulnerable;
    ReEntrancyExploit public exploitProof;

    function setUp() public {
        vulnerable = new ReEntrancyVulnerable();
        proof = new ReEntrancyProof();
        exploitVulnerable = new ReEntrancyExploit(address(vulnerable));
        exploitProof = new ReEntrancyExploit(address(proof));

        // send 5 ether to the vulnerable contract
        vm.deal(address(vulnerable), 5 ether);
        // send 5 ether to the proof contract
        vm.deal(address(proof), 5 ether);
    }

    function testDeploy() public {
        assertTrue(address(vulnerable) != address(0));
        assertTrue(address(proof) != address(0));
        assertTrue(address(exploitVulnerable) != address(0));
    }

    function testExploitOnVulnerable() public {
        // check that the vulnerable contract has 5 ether
        assertEq(address(vulnerable).balance, 5 ether);

        // call the exploit function
        exploitVulnerable.exploit{value: 1 ether}();

        // check that the exploit contract has 0 ether
        assertEq(address(vulnerable).balance, 0);
    }

    function testExploitOnProof() public {
        // check that the vulnerable contract has 5 ether
        assertEq(address(proof).balance, 5 ether);

        // call the exploit function
        exploitProof.exploit{value: 1 ether}();

        // check that the exploit contract has 5 ether
        assertEq(address(proof).balance, 5 ether);
    }
}
