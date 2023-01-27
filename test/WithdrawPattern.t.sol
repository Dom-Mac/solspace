// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import 'forge-std/Test.sol';
import {WithdrawAuction} from '../src/WithdrawPattern/WithdrawAuction.sol';
import {MaliciousWP} from '../src/WithdrawPattern/MaliciousWP.sol';
import {SenderAuction} from '../src/WithdrawPattern/SenderAuction.sol';

error Powned();

/**
 * @title Withdraw Pattern Test
 * @author Dom-Mac
 */
contract WithdrawPatternTest is Test {
  WithdrawAuction withdrawAuction;
  MaliciousWP attackSender;
  MaliciousWP attackWithdraw;
  SenderAuction senderAuction;

  address firstBidder = address(10);
  address thirdBidder = address(30);

  function setUp() public {
    senderAuction = new SenderAuction();
    withdrawAuction = new WithdrawAuction();
    attackSender = new MaliciousWP(address(senderAuction));
    attackWithdraw = new MaliciousWP(address(withdrawAuction));

    // send eth to bidders
    vm.deal(firstBidder, 3 ether);
    vm.deal(thirdBidder, 3 ether);
  }

  function testExploitOnVulnerable() public {
    /**
     * @dev FirstBidder bids 1.5 ether to the vulnerable contract.
     *      - Check the contract balance
     *      - Assert highest bidder is firstBidder
     */
    uint256 bidValue = 1.5 ether;

    vm.prank(firstBidder); // set msg.sender for next transaction only
    senderAuction.bid{value: bidValue}(); // bid

    assertEq(address(senderAuction).balance, bidValue);
    assertEq(senderAuction.highestBidder(), firstBidder);

    /**
     * @dev Call the exploit function thath will
     *      bid on behalf of the malicious contract
     *      - Check if previous bidder has received his ethers
     *        and so that the auction balance is bidValue
     *      - Check that the malicious contract is the highest bidder
     */
    bidValue = 2 ether;

    attackSender.exploit{value: bidValue}();
    assertEq(address(senderAuction).balance, bidValue);
    assertEq(senderAuction.highestBidder(), address(attackSender));

    /**
     * @dev So far so good, the previous bidder has received
     *      and nothing seems wrong.
     *      Now we will try to make a new bid on behalf of the
     *      thirdBidder.
     *      - Expect the bid to revert
     *      - Powned! The malicious contract will be
     *        the highest bidder forever
     */
    bidValue = 2.5 ether;

    vm.prank(thirdBidder); // set msg.sender for next transaction only
    vm.expectRevert(Powned.selector);
    senderAuction.bid{value: bidValue}(); // bid
    assertEq(senderAuction.highestBidder(), address(attackSender));
  }

  function testExploitOnProof() public {
    /**
     * @dev FirstBidder bids 1.5 ether to the vulnerable contract.
     *      - Check the contract balance
     *      - Assert highest bidder is firstBidder
     *
     * @notice The proof contract is
     */
    uint256 bidValue = 1.5 ether;

    vm.prank(firstBidder); // set msg.sender for next transaction only
    senderAuction.bid{value: bidValue}(); // bid

    assertEq(address(senderAuction).balance, bidValue);
    assertEq(senderAuction.highestBidder(), firstBidder);

    /**
     * @dev Call the exploit function thath will
     *      bid on behalf of the malicious contract
     *      - Check if previous bidder has received his ethers
     *        and so that the auction balance is bidValue
     *      - Check that the malicious contract is the highest bidder
     */
    bidValue = 2 ether;

    attackSender.exploit{value: bidValue}();
    assertEq(address(senderAuction).balance, bidValue);
    assertEq(senderAuction.highestBidder(), address(attackSender));

    /**
     * @dev So far so good, the previous bidder has received
     *      and nothing seems wrong.
     *      Now we will try to make a new bid on behalf of the
     *      thirdBidder.
     *      - Expect the bid to revert
     *      - Powned! The malicious contract will be
     *        the highest bidder forever
     */
    bidValue = 2.5 ether;

    vm.prank(thirdBidder); // set msg.sender for next transaction only
    vm.expectRevert(Powned.selector);

    senderAuction.bid{value: bidValue}(); // bid
    assertEq(senderAuction.highestBidder(), address(attackSender));
  }
}
