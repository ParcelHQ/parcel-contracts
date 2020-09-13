pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT


import "./interfaces/IENSResolver.sol";
import "./interfaces/IUniswap.sol";
import "./interfaces/IERC1620.sol";
import "./interfaces/IReverseRegistrar.sol";

contract ParcelStorage {
    address public owner;
    address public factoryAddress;
    mapping(uint8 => string) public files;
    uint256[] public streamIds;
    address public ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public WETH_ADDRESS = 0xc778417E063141139Fce010982780140Aa0cD5Ab;

    address public publicResolverAddr = 0xf6305c19e814d2a75429Fd637d01F7ee0E77d615;
    IENSResolver ENSResolver = IENSResolver(publicResolverAddr); // get a handle for the ENSResolver contract

    address public reverseRegistrar = 0x6F628b68b30Dc3c17f345c9dbBb1E483c2b7aE5c;
    IReverseRegistrar ReverseRegistrar = IReverseRegistrar(reverseRegistrar); // get a handle for the Reverse Registrar contract

    address public uniswapRouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    IUniswap uniswap = IUniswap(uniswapRouterAddress); // get a handle for the Uniswap contract

    address public sablierAddress = 0x7ee114C3628Ca90119fC699f03665bF9dB8f5faF;
    IERC1620 sablier = IERC1620(sablierAddress); // get a handle for the Sablier contract
}
