// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract WETHPointer {
    address WETH_ADDR;

    constructor(address weth_addr) {
        WETH_ADDR = weth_addr;
    }

    function pointToWETH() public view returns(address) {
        return WETH_ADDR;
    }
}
