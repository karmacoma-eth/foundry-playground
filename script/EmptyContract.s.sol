// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {EmptyContract} from "src/EmptyContract.sol";

contract EmptyContractDeployer is Script {
    function run() public {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        console2.log("Deployer address", vm.addr(pk));

        vm.startBroadcast(pk);
        address deployed = address(new EmptyContract());
        console2.log("Deployed EmptyContract at", deployed);
        vm.stopBroadcast();
    }
}

