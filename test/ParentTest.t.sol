// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

contract Base {
    function frob() public pure returns (uint256) {
        return 42;
    }

    function blep() public pure returns (uint256) {
        return 42;
    }
}

contract ChildA is Base {
    function moop() public pure returns (uint256) {
        return 0xc0ffee;
    }
}

contract ChildB is Base {
    function momp() public pure returns (uint256) {
        return 0xdead;
    }
}

abstract contract BaseTest is Test {
    Base internal testee;

    function setUp() public virtual;

    function test_frob() public {
        assertEq(testee.frob(), 42);
    }

    function test_blep() public {
        assertEq(testee.blep(), 42);
    }
}

contract ChildATest is BaseTest {
    function setUp() public override {
        testee = new ChildA();
    }

    function test_moop() public {
        assertEq(ChildA(address(testee)).moop(), 0xc0ffee);
    }
}

contract ChildBTest is BaseTest {
    function setUp() public override {
        testee = new ChildB();
    }

    function test_momp() public {
        assertEq(ChildB(address(testee)).momp(), 0xdead);
    }
}
