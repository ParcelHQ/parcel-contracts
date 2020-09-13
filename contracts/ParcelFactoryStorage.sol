pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT


import "./ParcelWallet.sol";
import "./interfaces/IENS.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/IParcelWallet.sol";
import "./interfaces/IDefaultResolver.sol";

contract ParcelFactoryStorage {
    address payable public admin;
    mapping(address => address) public registered;
    address[] public registeredWallets;
    address public publicResolverAddr = 0xf6305c19e814d2a75429Fd637d01F7ee0E77d615;
    IENSResolver ENSResolver = IENSResolver(publicResolverAddr);
    IENS ENSRegistry = IENS(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e);
    ERC20 dai = ERC20(0xc3dbf84Abb494ce5199D5d4D815b10EC29529ff8);
    ERC20 usdc = ERC20(0x472d88e5246d9bF2AB925615fc580336430679Ae);
}
