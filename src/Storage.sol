// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Storage {
    function read_storage(uint256 slot) internal view returns (uint256 value) {
        assembly {
            value := sload(slot)
        }
    }

    function write_storage(uint256 slot, uint256 value) internal {
        assembly {
            sstore(slot, value)
        }
    }
}


