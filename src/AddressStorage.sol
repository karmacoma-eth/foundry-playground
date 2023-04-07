// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract AddressStorage {
    address public owner;

    constructor() {
        assembly {
            // save a little coffee for later
            sstore(owner.slot, shl(188, 0xC0FFEEC0FFEE))
        }

        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "ONLY_OWNER");
        owner = newOwner;
    }

    function stompOwnership(address newOwner) public {
        require(msg.sender == owner, "ONLY_OWNER");
        assembly {
            sstore(owner.slot, newOwner)
        }
    }
}
