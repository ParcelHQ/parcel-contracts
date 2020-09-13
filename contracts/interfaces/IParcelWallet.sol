pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT


interface IParcelWallet {
    function setEns(
        bytes32 node,
        address addr,
        string calldata _name
    ) external returns (bool);
}
