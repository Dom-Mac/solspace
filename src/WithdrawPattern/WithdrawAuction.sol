// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/**
 * @title Withdraw Pattern | Auction
 * @author Dom-Mac <dom@dommac.dev>
 *
 * @notice The goal is to implement an auction in wich
 *         we store the highest bidder and the amount of ether sent.
 *         Past bidders should be able to reiceve their
 *         ethers back once their bid is overtaken.
 *
 * @notice The right way to implement this auction is
 *         to store the previous bidders in a mapping
 *         and give them the possibility to
 *         withdraw their ethers.
 *
 * @notice The withdraw pattern consists ingiving
 *         the possibility to the users to
 *         withdraw their ethers instead of
 *         sending them directly as an effect of
 *         another action.
 */
contract WithdrawAuction {
  address public highestBidder;
  uint256 public highestBid;
  /**
   * @dev store ethers to send to the previous highest bidder
   */
  mapping(address => uint256) pendingReturns;

  error NotEnoughEther();

  function bid() public payable {
    if (msg.value <= highestBid) revert NotEnoughEther();
    /**
     * @dev store ethers to send to the previous highest bidder
     */
    pendingReturns[highestBidder] += highestBid;

    highestBidder = msg.sender;
    highestBid = msg.value;
  }

  function withdraw() public {
    uint256 amount = pendingReturns[msg.sender];
    if (amount > 0) {
      /**
       * @dev reset the pending return to 0
       */
      pendingReturns[msg.sender] = 0;
      /**
       * @dev send the pending return
       */
      payable(msg.sender).transfer(amount);
    }
  }
}
