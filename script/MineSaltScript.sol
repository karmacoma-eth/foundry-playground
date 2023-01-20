// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {Counter} from "src/Counter.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        bytes32 initCodeHash = keccak256(type(Counter).creationCode);

        string[] memory args = new string[](6);
        args[0] = "cast";
        args[1] = "create2";
        args[2] = "--starts-with";
        args[3] = "c001";
        args[4] = "--init-code-hash";
        args[5] = string(abi.encodePacked(initCodeHash));
        bytes memory result = vm.ffi(args);
        console2.log("result", string(result));
    }
}
