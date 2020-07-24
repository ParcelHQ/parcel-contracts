//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

contract ParcelStorage {
    address public owner;
    mapping(uint8 => bytes) public files;
}
