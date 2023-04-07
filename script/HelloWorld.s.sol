// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {LibString} from "solady/utils/LibString.sol";

import {HelloWorld} from "src/HelloWorld.sol";

contract HelloWorldDeployer is Script {
    function submit(bytes memory bytecode, string memory rpcUrl) public {
        string[] memory inputs = new string[](7);
        inputs[0] = "curl";
        inputs[1] = "-X";
        inputs[2] = "POST";
        inputs[3] = "--data";
        inputs[4] = LibString.toHexStringNoPrefix(bytecode);
        inputs[5] = rpcUrl;
        inputs[6] = "-s";
        vm.ffi(inputs);
    }

    function run() public {
        submit(type(HelloWorld).creationCode, "http://localhost:8888");
    }
}
