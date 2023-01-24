// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

abstract contract ReEntrancyInterface {
    mapping(address => uint256) public balances;

    function deposit() external payable virtual;

    function withdraw() external virtual;
}
