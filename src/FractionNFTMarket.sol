// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Receipttoken} from "./ERC20Token.sol";
import {MockNFT} from "./MockNFT.sol";

contract FractionNFTMarket {
    struct FractionSales {
        uint tokenId;
        address NFTAddress;
        address ERC20TokenAddress;
        uint ERC20tokenSupply;
        uint ERC20TokenBalance;
        uint ERC20TokenFractionBalance;
        uint priceperfraction;
        address[] buyer;
        address platform;
        uint salesBalance;
        bool active;
    }
    address contractDeployer;
    mapping(uint => FractionSales) public mapSales;
    uint salesId;

    constructor() {
        contractDeployer = msg.sender;
    }

    function createNFTFraction(
        uint _tokenId,
        uint _ERC20tokenSupply,
        uint _priceperfraction,
        address _NFTAddress,
        address _ERC20TokenAddress
    ) public {
        FractionSales storage fractionSales = mapSales[salesId];
        fractionSales.ERC20TokenAddress = _ERC20TokenAddress;
        fractionSales.NFTAddress = _NFTAddress;
        //say 7 ether = 3 MockToken; = 1 fraction
        fractionSales.priceperfraction = _priceperfraction;
        fractionSales.platform = msg.sender;
        fractionSales.ERC20tokenSupply = _ERC20tokenSupply;
        fractionSales.tokenId = _tokenId;
        fractionSales.ERC20TokenBalance = fractionSales.ERC20tokenSupply;
        MockNFT(fractionSales.NFTAddress).mint(
            msg.sender,
            fractionSales.tokenId
        );
        Receipttoken(fractionSales.ERC20TokenAddress).mint(
            msg.sender,
            fractionSales.ERC20tokenSupply
        );
        fractionSales.active = true;
    }

    function buyNFTFraction(uint _salesId) public payable {
        FractionSales storage fractionSales = mapSales[_salesId];
        require(fractionSales.active == true, "NFt not active");
        //say 7 ether = 3 MockToken; = 1 fraction
        fractionSales.ERC20TokenBalance =
            fractionSales.priceperfraction *
            msg.value;
        fractionSales.salesBalance += msg.value;
        fractionSales.buyer.push(msg.sender);
        Receipttoken(fractionSales.ERC20TokenAddress).transfer_(
            fractionSales.platform,
            msg.sender,
            fractionSales.ERC20TokenBalance
        );
        uint payContract = (1 * msg.value) / 1000;
        uint payPlatform = msg.value - payContract;
        payable(fractionSales.platform).transfer(payPlatform);
        payable(contractDeployer).transfer(payContract);
        require(
            (msg.sender).balance >= fractionSales.ERC20tokenSupply,
            "You own all the fraction of token"
        );
        MockNFT(fractionSales.NFTAddress).setApprovalForAll(
            address(this),
            true
        );
        MockNFT(fractionSales.NFTAddress).transferFrom(
            fractionSales.platform,
            msg.sender,
            fractionSales.tokenId
        );
        fractionSales.active = false;
    }
}
