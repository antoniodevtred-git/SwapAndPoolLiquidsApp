// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "./interfaces/IV2Router02.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract SwappApp {
    address public owner;
    IV2Router02 public router;

    constructor(address _router) {
        owner = msg.sender;
        router = IV2Router02(_router);
    }

    // Swap tokens
    function swapTokens(
        address tokenIn_,
        address tokenOut_,
        uint amountIn_,
        uint amountOutMin_,
        address to_
    ) external {
        require(IERC20(tokenIn_).transferFrom(msg.sender, address(this), amountIn_), "01");
        require(IERC20(tokenIn_).approve(address(router), amountIn_), "02");

        address[] memory path = new address[](2);
        path[0] = tokenIn_;
        path[1] = tokenOut_;

        router.swapExactTokensForTokens(
            amountIn_,
            amountOutMin_,
            path,
            to_,
            block.timestamp + 600
        );
    }

    // Add liquidity
    function addLiquidity(
        address tokenA_,
        address tokenB_,
        uint amountADesired_,
        uint amountBDesired_,
        uint amountAMin_,
        uint amountBMin_,
        address to_
    ) external {
        require(IERC20(tokenA_).transferFrom(msg.sender, address(this), amountADesired_), "03");
        require(IERC20(tokenB_).transferFrom(msg.sender, address(this), amountBDesired_), "04");

        require(IERC20(tokenA_).approve(address(router), amountADesired_), "05");
        require(IERC20(tokenB_).approve(address(router), amountBDesired_), "06");

        router.addLiquidity(
            tokenA_,
            tokenB_,
            amountADesired_,
            amountBDesired_,
            amountAMin_,
            amountBMin_,
            to_,
            block.timestamp + 600
        );
    }

    // Remove liquidity
    function removeLiquidity(
        address tokenA_,
        address tokenB_,
        uint liquidity_,
        uint amountAMin_,
        uint amountBMin_,
        address to_
    ) external {
        address pair = pairFor(tokenA_, tokenB_);
        require(IERC20(pair).transferFrom(msg.sender, address(this), liquidity_), "07");
        require(IERC20(pair).approve(address(router), liquidity_), "08");

        router.removeLiquidity(
            tokenA_,
            tokenB_,
            liquidity_,
            amountAMin_,
            amountBMin_,
            to_,
            block.timestamp + 600
        );
    }

    // Helper (no implementado aún)
    function pairFor(address tokenA_, address tokenB_) public pure returns (address) {
        revert("pairFor not implemented");
    }
}
