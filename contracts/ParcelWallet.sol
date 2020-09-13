pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT


import "./ParcelStorage.sol";
import "./interfaces/IERC20.sol";

contract ParcelWallet is ParcelStorage {
    constructor(address _owner, address _factoryAddress) public {
        owner = _owner;
        factoryAddress = _factoryAddress;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Not the Owner");
        _;
    }

    function addFile(uint8 index, string calldata hash)
        external
        onlyOwner
        returns (bool)
    {
        files[index] = hash;
        return true;
    }

    function setEns(
        bytes32 node,
        address addr,
        string calldata _name
    ) external onlyFactory returns (bool) {
        ENSResolver.setAddr(node, addr);
        ReverseRegistrar.setName(_name);
        return true;
    }

    function getStreamIds() public view returns (uint256[] memory) {
        return streamIds;
    }

    modifier onlyFactory {
        require(msg.sender == factoryAddress, "Unauthorized");
        _;
    }

    // Mass Payout
    function massPayout(
        address employerToken,
        address[] memory employeeToken,
        address payable[] memory employeeAddress,
        uint256[] memory values
    ) public payable {
        for (uint256 i = 0; i < employeeAddress.length; i++) {
            if (employerToken == employeeToken[i]) {
                _send(employeeToken[i], employeeAddress[i], values[i]);
            } else {
                address[] memory _path = new address[](2);
                _path[0] = employerToken;
                _path[1] = employeeToken[i];
                _swapTokenToToken(_path, values[i], employeeAddress[i]);
            }
        }
    }

    // Mass Money Streaming
    function streamMoney(
        address[] calldata recipients,
        uint256[] calldata values,
        address[] calldata tokensToStream,
        uint256[] calldata stopTime
    ) external returns (uint256[] memory) {
        for (uint256 i = 0; i < recipients.length; i++) {
            ERC20 token = ERC20(tokensToStream[i]); // get a handle for the token contract
            uint256 allowed = token.allowance(address(this), address(sablier)); // check for allowance to sablier contract
            if (allowed < values[i]) {
                token.approve(address(sablier), values[i]);
            }

            // the stream id is needed later to withdraw from or cancel the stream
            uint256 streamId = sablier.createSalary(
                recipients[i],
                values[i],
                tokensToStream[i],
                block.timestamp,
                block.timestamp + stopTime[i]
            );
            streamIds.push(streamId);
        }

        return streamIds;
    }

    function _send(
        address _employeeToken,
        address payable _employeeAddress,
        uint256 _value
    ) internal {
        if (_employeeToken == ethAddress) {
            (_employeeAddress).transfer(_value);
        } else {
            ERC20 erc20 = ERC20(_employeeToken);
            erc20.transfer(_employeeAddress, _value);
        }
    }

    function _swapTokenToToken(
        address[] memory path,
        uint256 amountOut,
        address _employeeAddresss
    ) internal {
        ERC20 erc20 = ERC20(path[0]);
        erc20.approve(uniswapRouterAddress, uint256(-1));
        uniswap.swapTokensForExactTokens(
            amountOut,
            uint256(-1),
            path,
            _employeeAddresss,
            now + 12000
        );
    }

    receive() external payable {}
}
