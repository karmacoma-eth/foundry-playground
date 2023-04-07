// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {stdJson} from "forge-std/StdJson.sol";

import "forge-std/Test.sol";

contract JsonTest is Test {
    function testEmptyJson() public {
        string memory json = '{"name":"John","age":30,"city":"New York"}';

        // works
        assertEq(stdJson.readString(json, ".name"), "John");

        // crashes with
        //  The application panicked (crashed).
        //  Message:  index out of bounds: the len is 0 but the index is 0
        //  Location: evm/src/executor/inspector/cheatcodes/ext.rs:424
        stdJson.readString(json, ".darkest_secret");
    }

    function testEscapedQuotes() public {
        string memory json = '{"foo":"quotation mark: \'\\"\' and backslash: \\\\"}';

        assertEq(stdJson.readString(json, ".foo"), 'quotation mark: \'"\' and backslash: \\');
    }
}
