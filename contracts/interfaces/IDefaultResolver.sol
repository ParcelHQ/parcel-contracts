pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT

interface IDefaultResolver {
    function name(bytes32 node) external view returns (string memory);
}
