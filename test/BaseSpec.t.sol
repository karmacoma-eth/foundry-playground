// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

contract Base {
    function frob() public pure returns (uint256) {
        return 42;
    }

    function beep() public pure returns (uint256) {
        return 42;
    }

    function boop() public pure returns (uint256) {
        return 42;
    }
}

contract Mooper is Base {
    function moop() public pure returns (uint256) {
        return 0xc0ffee;
    }
}

contract Momper is Base {
    function momp() public pure returns (uint256) {
        return 0xdead;
    }
}


abstract contract BaseProvider is Test {
    /// specific test contracts must provide a way to configure a Base implementation
    function create() public virtual returns(Base);
}

abstract contract BeepTestMixin is BaseProvider {
    Base beep_mixin_base;

    function setUp() public virtual {
        beep_mixin_base = create();
    }

    function test_beep() public {
        assertEq(beep_mixin_base.beep(), 42);
    }
}

abstract contract BoopTestMixin is BaseProvider {
    Base boop_mixin_base;

    function setUp() public virtual {
        boop_mixin_base = create();
    }

    function test_boop() public {
        assertEq(boop_mixin_base.boop(), 42);
    }
}

abstract contract BaseSpec is BeepTestMixin, BoopTestMixin {
    Base base;

    function setUp() public virtual override(BeepTestMixin, BoopTestMixin) {
        base = create();

        BeepTestMixin.setUp();
        BoopTestMixin.setUp();
    }

    // we expect all Base implementations to frob() correctly
    function test_frob() public {
        assertEq(create().frob(), 42);
    }
}

contract MooperTest is BaseSpec {
    Mooper mooper;

    function setUp() public override {
        super.setUp();
        mooper = new Mooper();
    }

    function create() public override returns(Base) {
        return new Mooper();
    }

    function test_moop() public {
        assertEq(mooper.moop(), 0xc0ffee);
    }
}

contract MomperTest is BaseSpec {
    Momper momper;

    function setUp() public override {
        super.setUp();
        momper = new Momper();
    }

    function create() public override returns(Base) {
        return new Momper();
    }

    function test_momp() public {
        assertEq(momper.momp(), 0xdead);
    }
}
