//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./ParcelProxy.sol";
import "./interfaces/IENS.sol";

contract ParcelFactory {
    using SafeMath for uint256;

    mapping(address => address) public registered;
    ENS ENSRegistry = ENS(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e);
    address
        public publicResolverAddr = 0xf6305c19e814d2a75429Fd637d01F7ee0E77d615;
    PublicResolver ENSResolver = PublicResolver(publicResolverAddr);

    // modifier oneAccount {
    //     require(registered[msg.sender] == address(0), "account exists");
    //     _;
    // }
    function changeENSOwner(bytes32 _node, address _newOwner) external {
        ENSRegistry.setOwner(_node, _newOwner);
    }

    function createSubDomain(
        bytes32 _node,
        bytes32 _label,
        address _ownerOfSubdomain
    ) external {
        ENSRegistry.setSubnodeOwner(_node, _label, _ownerOfSubdomain);
    }

    function createSubnodeOwner(
        bytes32 _node,
        bytes32 _label,
        address _ownerOfSubdomain
    ) external {
        ENSRegistry.setSubnodeRecord(
            _node,
            _label,
            _ownerOfSubdomain,
            publicResolverAddr,
            0
        );
    }

    function setAdd(bytes32 _ownerNode, address _owner) external {
        ENSResolver.setAddr(_ownerNode, _owner);
    }

    /**
     * @dev Registers an ens org
     * @param _node Namehash of parcelid (e.g. "0x15eac8f5a11394d34a5b1073c9555027ae0ad90090cfa79b91bf12b4a3413670")
     * @param _label Keccak256 hash of subdomain (eg. in 'apple.parcelid.eth', hash ONLY apple: "0x85dca312121b082f39dd34192d69dffd93c0add33dac13f7846f2975fba845c6")
     * @param _ownerNode Namehash of subdomain. This is the whole ens domain (e.g. apple.parcelid.eth)
     */
    function register(
        bytes32 _node,
        bytes32 _label,
        bytes32 _ownerNode
    ) external payable returns (address) {
        ENSRegistry.setSubnodeRecord(
            _node,
            _label,
            address(this),
            publicResolverAddr,
            0
        );
        ENSResolver.setAddr(_ownerNode, address(this));

        ParcelProxy newAccount = new ParcelProxy(msg.sender);
        registered[msg.sender] = address(newAccount);

        ENSRegistry.setSubnodeOwner(_node, _label, address(newAccount));

        PublicResolver myAccount = PublicResolver(address(newAccount));
        myAccount.setAddr(_ownerNode, address(newAccount));

        return address(newAccount);
    }
}
