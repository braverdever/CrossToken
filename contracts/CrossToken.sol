// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CrossToken is ERC20, Ownable {
    uint256 public initialSupply = 100000000;
    uint256 public seedSaleSupply = 12000000;
    uint256 public privateSaleSupply = 11000000;
    uint256 public publicSaleSupply = 8000000;
    constructor() ERC20("Cross", "CROSS") Ownable() {
        _mint(msg.sender, initialSupply);
    }

    function setSeedSale(address seedSale) public onlyOwner {
        _transfer(address(this), seedSale, seedSaleSupply);
    }

    function setPrivateSale(address privateSale) public onlyOwner {
        _transfer(address(this), privateSale, privateSaleSupply);
    }

    function setPublicSale(address publicSale) public onlyOwner {
        _transfer(address(this), publicSale, publicSaleSupply);
    }
}
