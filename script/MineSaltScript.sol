// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {StdAssertions} from "forge-std/StdAssertions.sol";

import {LibString} from "solady/utils/LibString.sol";

import {Counter} from "src/Counter.sol";

contract CounterScript is Script, StdAssertions {
    using LibString for bytes;

    function setUp() public {}

    function mineSalt(bytes32 initCodeHash, string memory startsWith)
        public
        returns (bytes32 salt, address expectedAddress)
    {
        string[] memory args = new string[](6);
        args[0] = "cast";
        args[1] = "create2";
        args[2] = "--starts-with";
        args[3] = startsWith;
        args[4] = "--init-code-hash";
        args[5] = LibString.toHexStringNoPrefix(uint256(initCodeHash), 32);
        string memory result = string(vm.ffi(args));

        uint256 addressIndex = LibString.indexOf(result, "Address: ");
        string memory addressStr = LibString.slice(result, addressIndex + 9, addressIndex + 9 + 42);
        expectedAddress = vm.parseAddress(addressStr);

        uint256 saltIndex = LibString.indexOf(result, "Salt: ");
        string memory saltStr = LibString.slice(result, saltIndex + 6, bytes(result).length);
        salt = bytes32(vm.parseUint(saltStr));
    }

    function run() public {
        bytes32 initCodeHash = keccak256(type(Counter).creationCode);
        (bytes32 salt, address expectedAddress) = mineSalt(initCodeHash, "c0ffee");

        // DEPLOY
        vm.startBroadcast();
        address actualAddress = address(new Counter{salt: bytes32(salt)}());
        vm.stopBroadcast();

        assertEq(actualAddress, expectedAddress);
        console2.log("Deployed Counter at", actualAddress);
    }
}
