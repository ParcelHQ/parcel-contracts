pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./EIP712.sol";

contract ParcelMeta is EIP712 {
    struct Signature {
        bytes32 r;
        bytes32 s;
        uint8 v;
    }

    mapping(address => mapping(uint8 => string)) public files;

    function addFile(
        address signer,
        Signature calldata signature,
        uint8 index,
        string calldata hash
    ) external {
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        META_TRANSACTION_TYPEHASH,
                        signer,
                        nonces[signer]
                    )
                )
            )
        );

        require(signer != address(0), "invalid-address-0");
        require(
            signer == ecrecover(digest, signature.v, signature.r, signature.s),
            "invalid-signatures"
        );

        files[signer][index] = hash;
        nonces[signer]++;
    }
}
