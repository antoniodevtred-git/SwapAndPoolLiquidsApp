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
    // 🔴 NO calcules el pair aquí
    // El usuario ya aprobó el LP token al router

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
    // Devuelve una dirección simulada que dependa de los tokens
        return address(uint160(uint256(keccak256(abi.encodePacked(tokenA_, tokenB_)))));
    }

}
