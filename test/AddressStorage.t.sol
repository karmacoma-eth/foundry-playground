// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {AddressStorage} from "../src/AddressStorage.sol";

contract AddressStorageTest is Test {
    AddressStorage public addressStorage;

    function setUp() public {
        addressStorage = new AddressStorage();
    }

    function testOwnerStorage() public {
        bytes32 slot = 0;

        console2.log("### after constructor ###");
        console2.log("addressStorage.owner():", addressStorage.owner());
        console2.log("storage slot contents:");
        console2.logBytes32(vm.load(address(addressStorage), slot));

        addressStorage.transferOwnership(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

        console2.log();
        console2.log("### after transferring ownership to dolphin address ###");
        console2.log("addressStorage.owner():", addressStorage.owner());
        console2.log("storage slot contents:");
        console2.logBytes32(vm.load(address(addressStorage), slot));

        vm.prank(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
        addressStorage.stompOwnership(0x03433830468d771A921314D75b9A1DeA53C165d7);

        console2.log();
        console2.log("### after stomping ownership ###");
        console2.log("addressStorage.owner():", addressStorage.owner());
        console2.log("storage slot contents:");
        console2.logBytes32(vm.load(address(addressStorage), slot));
    }
}
