// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./ICrossToken.sol";
import "./IVestingNFT.sol";

contract PublicSale is Ownable, Pausable {
    ICrossToken public token;
    IVestingNFT public vestingNFT;
    uint256 public tokenPrice;
    uint256 public vestingPeriod = 90 days;
    mapping(address => uint256) public balanceOf;

    event TokensPurchased(
        address indexed purchaser,
        address indexed beneficiary,
        uint256 value,
        uint256 amount
    );

    constructor(ICrossToken _token, uint256 _tokenPrice) Ownable() {
        token = _token;
        tokenPrice = _tokenPrice;
    }

    function buyTokens() public payable whenNotPaused {
        require(
            token.balanceOf(address(this)) >= msg.value / tokenPrice,
            "Not enough tokens available."
        );

        uint256 amountToBuy = msg.value / tokenPrice;
        require(amountToBuy > 0, "Amount to buy is 0.");

        balanceOf[msg.sender] += amountToBuy;
        vestingNFT.create(
            msg.sender,
            amountToBuy,
            block.timestamp + vestingPeriod,
            token
        );

        emit TokensPurchased(
            msg.sender,
            address(token),
            msg.value,
            amountToBuy
        );
    }

    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "No funds to withdraw");
        payable(owner()).transfer(address(this).balance);
    }

    function pauseSale() public onlyOwner {
        _pause();
    }

    function unpauseSale() public onlyOwner {
        _unpause();
    }
}
