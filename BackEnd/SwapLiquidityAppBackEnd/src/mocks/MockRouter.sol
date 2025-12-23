// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "../interfaces/IV2Router02.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract MockRouter is IV2Router02 {
    address public tokenA;
    address public tokenB;
    address public lpToken; // ✅ NUEVO: Almacenamos el LP token mockeado

    // ✅ NUEVO: Setter para el LP token
    function setPair(address _lpToken) external {
        lpToken = _lpToken;
    }

    function setTokens(address tokenA_, address tokenB_) external {
        tokenA = tokenA_;
        tokenB = tokenB_;
    }

    function addLiquidity(
        address, address, uint256, uint256, uint256, uint256, address, uint256
    ) external pure override returns (uint256, uint256, uint256) {
        return (100, 100, 10); // valores mock
    }

    function swapExactTokensForTokens(
        uint256 amountIn_,
        uint256 amountOutMin_,
        address[] calldata path_,
        address to_,
        uint256
    ) external override returns (uint256[] memory) {
        IERC20(path_[0]).transferFrom(msg.sender, address(this), amountIn_);
        IERC20(path_[1]).transfer(to_, amountOutMin_);

        uint256[] memory result = new uint256[](2);
        result[0] = amountIn_;
        result[1] = amountOutMin_;
        return result;
    }

    function removeLiquidity(
    address tokenA_,
    address tokenB_,
    uint256,
    uint256,
    uint256,
    address to_,
    uint256
) external override returns (uint256 amountA, uint256 amountB) {
    amountA = 50 ether;
    amountB = 50 ether;

    // 🔥 TRANSFERENCIA REAL (esto faltaba)
    IERC20(tokenA_).transfer(to_, amountA);
    IERC20(tokenB_).transfer(to_, amountB);
}
}
