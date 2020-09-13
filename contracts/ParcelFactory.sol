pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT


import "./ParcelFactoryStorage.sol";

contract ParcelFactory is ParcelFactoryStorage {
    constructor() public {
        admin = msg.sender;
    }

    modifier onlyAdmin {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier oneAccount {
        require(registered[msg.sender] == address(0), "account exists");
        _;
    }

    function changeAdmin(address payable _newAdmin)
        public
        onlyAdmin
        returns (bool)
    {
        admin = _newAdmin;
    }

    function changeENSOwner(bytes32 _node, address _newOwner)
        external
        onlyAdmin
        returns (bool)
    {
        ENSRegistry.setOwner(_node, _newOwner);
        return true;
    }

    function getParcelWallets() external view returns (address[] memory) {
        return registeredWallets;
    }

    function register(
        bytes32 _node,
        bytes32 _label,
        bytes32 _ownerNode,
        string calldata _name
    ) external payable oneAccount returns (address) {
        ENSRegistry.setSubnodeRecord(
            _node,
            _label,
            address(this),
            publicResolverAddr,
            0
        );

        ParcelWallet newAccount = new ParcelWallet(msg.sender, address(this)); // Create a new smart contract wallet for org
        address payable parcelWalletAddress = address(newAccount);

        ENSResolver.setAddr(_ownerNode, address(this));
        ENSRegistry.setSubnodeOwner(_node, _label, parcelWalletAddress); // Assign ENS to parcel org
        IParcelWallet parcelWallet = IParcelWallet(parcelWalletAddress);
        try
            parcelWallet.setEns(_ownerNode, parcelWalletAddress, _name)
        returns (bool) {
            parcelWallet.setEns(_ownerNode, parcelWalletAddress, _name); // Set ENS and Reverse ENS
        } catch {
            revert("can't set ENS at Parcel Wallet");
        }

        // Send funds to the new account
        bool funded = _fundAccount(parcelWalletAddress);
        require(funded, "not enough funds");

        // Update storage
        registered[msg.sender] = parcelWalletAddress;
        registeredWallets.push(parcelWalletAddress);
        return parcelWalletAddress;
    }

    function _fundAccount(address payable _address) internal returns (bool) {
        dai.transfer(_address, 1000 * 1e18); // transfer 1000 DAI
        usdc.transfer(_address, 1000 * 1e6); // transfer 1000 USDC
        _address.transfer(0.1 ether); // transfer 0.1 ether
        return true;
    }

    function withdrawTestEth() external onlyAdmin returns (bool) {
        admin.transfer(address(this).balance);
    }

    receive() external payable {}
}

