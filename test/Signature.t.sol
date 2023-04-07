// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ECDSA} from "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

import "forge-std/Test.sol";

contract SignatureTest is Test {
    function testSigning() public {
        uint256 BOB_PRIVATE_KEY = 1;
        address BOB_PUBLIC_ADDRESS = vm.addr(BOB_PRIVATE_KEY);

        bytes32 dataToSign = keccak256(abi.encodePacked("somedata"));
        bytes32 hash = ECDSA.toEthSignedMessageHash(dataToSign);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(BOB_PRIVATE_KEY, hash);

        bytes memory sig = abi.encodePacked(r, s, v);

        // THIS ASSERTION FAILS
        assertEq(BOB_PUBLIC_ADDRESS, ECDSA.recover(hash, sig));
    }
}
