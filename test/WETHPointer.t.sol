// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import {WETHPointer} from "src/WETHPointer.sol";

contract WETHPointerTest is Test {
    WETHPointer public wethPointer;

    function setUp() public {
        wethPointer = new WETHPointer(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    }

    function testPointToWETH() public {
        console2.logBytes(address(wethPointer).code);
        assertEq(wethPointer.pointToWETH(), 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    }
}
