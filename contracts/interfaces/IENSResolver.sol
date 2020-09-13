pragma solidity ^0.6.0;

interface IENSResolver {
    function setAddr(bytes32 node, address addr) external;
}
