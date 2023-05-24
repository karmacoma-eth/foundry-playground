// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

contract PUSH0Test is Test {
    function test_push0() public {
        address echo = makeAddr("echo");

        bytes memory bytecode = hex"365f5f37365ff3";
        // CALLDATASIZE
        // PUSH0
        // PUSH0
        // CALLDATACOPY -> copies calldata at mem[0..calldatasize]

        // CALLDATASIZE
        // PUSH0 0x
        // RETURN -> returns mem[0..calldatasize]

        vm.etch(echo, bytecode);

        (bool success, bytes memory result) = echo.call(bytes("hello PUSH0"));
        assertTrue(success);
        assertEq(string(result), "hello PUSH0");
    }
}
