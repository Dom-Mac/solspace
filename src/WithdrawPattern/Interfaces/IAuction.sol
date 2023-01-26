// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IAuction {
    function bid() external payable;

    function withdraw() external;
}
