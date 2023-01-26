// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {WithdrawAuction} from "../src/WithdrawPattern/WithdrawAuction.sol";
import {MaliciousWP} from "../src/WithdrawPattern/MaliciousWP.sol";
import {SenderAuction} from "../src/WithdrawPattern/SenderAuction.sol";

/**
 * @title Withdraw Pattern Test
 * @author Dom-Mac
 */
contract WithdrawPatternTest is Test {
    WithdrawAuction withdrawAuction;
    MaliciousWP malicious;
    SenderAuction senderAuction;

    function setUp() public {
        senderAuction = new SenderAuction{value: 1 ether}();
        withdrawAuction = new WithdrawAuction{value: 1 ether}();
        malicious = new MaliciousWP(address(withdrawAuction));
    }

    function testExploitOnVulnerable() public {
        // check that the vulnerable contract has amount
        assertEq(address(senderAuction).balance, 1 ether);

        // call the exploit function
        malicious.exploit{value: 2 ether}();

        // now the malicious contract is the highest bidder
        assertEq(senderAuction.highestBidder(), address(malicious));
    }

    // function testExploitOnProof() public {}
}
