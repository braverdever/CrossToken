// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@ape.swap/erc-5725/contracts/IERC5725.sol";

interface IVestingNFT is IERC5725 {
    function create(
        address to,
        uint256 amount,
        uint256 releaseTimestamp,
        IERC20 token
    ) external;
}
