pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT

interface IReverseRegistrar {
    function setName(string calldata name) external returns (bytes32);
    function node(address addr) external pure returns (bytes32);
}
