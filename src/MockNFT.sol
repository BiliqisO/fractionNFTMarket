// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MockNFT is ERC721("MockNFT", "MNFT") {
    function mint(address recipient, uint256 tokenId) public payable {
        _mint(recipient, tokenId);
    }
}
