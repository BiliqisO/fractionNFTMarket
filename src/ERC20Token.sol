// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Receipttoken is ERC20 {
    constructor() ERC20("ReceiptToken", "RT") {}

    function mint(address account, uint256 value) external {
        _mint(account, value);
    }

    function transfer_(
        address owner,
        address to,
        uint256 value
    ) public virtual {
        _transfer(owner, to, value);
    }
}
