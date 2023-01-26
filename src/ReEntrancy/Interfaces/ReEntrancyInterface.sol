// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ReEntrancyInterface {
  function balances(address) external view returns (uint256);

  function deposit() external payable;

  function withdraw() external;
}
