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

    event TokensSwapped(address indexed user, address indexed tokenIn, address indexed tokenOut, uint256 amountIn, uint256 amountOutMin, address to);
    event LiquidityAdded(address indexed user, address indexed tokenA, address indexed tokenB, uint256 amountADesired, uint256 amountBDesired, address to);
    event LiquidityRemoved(address indexed user, address indexed tokenA, address indexed tokenB, uint256 liquidity, address to);

    // Swap tokens
    function swapTokens(address tokenIn_, address tokenOut_, uint256 amountIn_, uint256 amountOutMin_, address to_) external {
        require(IERC20(tokenIn_).transferFrom(msg.sender, address(this), amountIn_), "01");
        require(IERC20(tokenIn_).approve(address(router), amountIn_), "02");

        address[] memory path = new address[](2);
        path[0] = tokenIn_;
        path[1] = tokenOut_;

        router.swapExactTokensForTokens(amountIn_, amountOutMin_, path, to_, block.timestamp + 600);
        emit TokensSwapped(msg.sender, tokenIn_, tokenOut_, amountIn_, amountOutMin_, to_);

    }

    // Add liquidity
    function addLiquidity(address tokenA_, address tokenB_, uint256 amountADesired_, uint256 amountBDesired_, uint256 amountAMin_, uint256 amountBMin_, address to_) external {
        require(IERC20(tokenA_).transferFrom(msg.sender, address(this), amountADesired_), "03");
        require(IERC20(tokenB_).transferFrom(msg.sender, address(this), amountBDesired_), "04");

        require(IERC20(tokenA_).approve(address(router), amountADesired_), "05");
        require(IERC20(tokenB_).approve(address(router), amountBDesired_), "06");

        router.addLiquidity(tokenA_, tokenB_, amountADesired_, amountBDesired_, amountAMin_, amountBMin_, to_, block.timestamp + 600);
        emit LiquidityAdded(msg.sender, tokenA_, tokenB_, amountADesired_, amountBDesired_, to_);

    }

    // Remove liquidity
    function removeLiquidity(address tokenA_, address tokenB_, uint256 liquidity_, uint256 amountAMin_, uint256 amountBMin_, address to_) external {
        router.removeLiquidity(tokenA_, tokenB_, liquidity_, amountAMin_, amountBMin_, to_, block.timestamp + 600);
        emit LiquidityRemoved(msg.sender, tokenA_, tokenB_, liquidity_, to_);
    }

    function pairFor(address tokenA_, address tokenB_) public pure returns (address) {
    // Devuelve una dirección simulada que dependa de los tokens
        return address(uint160(uint256(keccak256(abi.encodePacked(tokenA_, tokenB_)))));
    }

}
