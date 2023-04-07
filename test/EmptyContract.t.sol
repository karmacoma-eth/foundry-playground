// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import {EmptyContract} from "src/EmptyContract.sol";

contract EmptyContractTest is Test {
    EmptyContract public empty;

    function setUp() public {
        empty = new EmptyContract();
    }

    function testDeployedBytecode() public view {
        console2.logBytes(address(empty).code);
    }
}
