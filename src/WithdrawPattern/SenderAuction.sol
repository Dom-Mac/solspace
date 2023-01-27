// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/**
 * @title Re-entrancy
 * @author Dom-Mac <dom@dommac.dev>
 *
 * @notice The goal is to implement an auction in wich
 *         we store the highest bidder and the amount of ether sent.
 *         Past bidders should be able to reiceve their
 *         ethers back once their bid is overtaken.
 *
 * @notice The first idea could be to send back the ethers
 *         to the previous bidders in the bid function.
 *
 * @notice The send pattern consists in sending
 *         ethers as the result of an effect.
 *
 * @notice The send pattern can lead to
 *         re-entrancy attacks and denial of service.
 */
contract SenderAuction {
  /**
   * @notice DO NOT USE - vulnerable contract
   */
  address public highestBidder;
  uint256 public highestBid;

  error NotEnoughEther();

  function bid() public payable {
    if (msg.value <= highestBid) revert NotEnoughEther();
    /**
     * @dev send ethers to the previous highest bidder
     */
    payable(highestBidder).transfer(highestBid);

    highestBidder = msg.sender;
    highestBid = msg.value;
  }
}
