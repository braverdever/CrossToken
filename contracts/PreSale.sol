// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICrossToken.sol";
import "./IVestingNFT.sol";

contract SeedSale is Ownable {
    ICrossToken public token;
    IVestingNFT public vestingNFT;
    uint256 public tokenPrice;
    uint256 public vestingPeriod = 180 days;
    bool public isActive;
    mapping(address => uint256) public balanceOf;
    mapping(address => bool) public isBuyable;

    event TokensPurchased(
        address indexed purchaser,
        address indexed beneficiary,
        uint256 value,
        uint256 amount
    );

    modifier whenActive() {
        require(isActive, "The sale is not active.");
        _;
    }

    modifier whenNotActive() {
        require(!isActive, "The sale is active.");
        _;
    }

    modifier onlyBuyable() {
        require(isBuyable[msg.sender], "Not added in the whitelist.");
        _;
    }

    constructor(ICrossToken _token, uint256 _tokenPrice) Ownable() {
        token = _token;
        tokenPrice = _tokenPrice;
    }

    function addInvestor(address investor) public whenNotActive onlyOwner {
        isBuyable[investor] = true;
    }

    function removeInvestor(address investor) public whenNotActive onlyOwner {
        isBuyable[investor] = false;
    }

    function buyTokens() public payable whenActive onlyBuyable {
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

    function startSale() public whenNotActive onlyOwner {
        _activateSale();
    }

    function endSale() public whenActive onlyOwner {
        uint256 remainingTokens = token.balanceOf(address(this));

        token.transfer(owner(), remainingTokens);
        payable(owner()).transfer(address(this).balance);
        _deactivateSale();
    }

    function _activateSale() internal {
        isActive = true;
    }

    function _deactivateSale() internal {
        isActive = true;
    }
}
