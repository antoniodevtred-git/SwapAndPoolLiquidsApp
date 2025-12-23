// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "../src/SwappApp.sol";
import "../src/mocks/MockRouter.sol";
import "../src/mocks/ERC20Mock.sol";

contract SwappAppTest is Test {
    SwappApp public app;
    ERC20Mock public tokenA;
    ERC20Mock public tokenB;
    ERC20Mock public lpToken;
    MockRouter public router;

    address public user = address(1);
    address public pair;

    function setUp() public {
        emit log("Deploying tokens...");
        tokenA = new ERC20Mock("Token A", "TKA", 18);
        tokenB = new ERC20Mock("Token B", "TKB", 18);

        emit log("Minting tokens...");
        tokenA.mint(user, 1000 ether);
        tokenB.mint(user, 1000 ether);

        emit log("Deploying router...");
        router = new MockRouter();
        emit log("Router deployed");

        emit log("Setting tokens in router...");
        router.setTokens(address(tokenA), address(tokenB));
        emit log("Tokens set");

        // Creamos y registramos el LP Token en el router
        lpToken = new ERC20Mock("LP Token", "LPT", 18); // ✅ global
        router.setPair(address(lpToken));

        emit log("Deploying app...");
        app = new SwappApp(address(router));
        emit log("App deployed");

        vm.label(user, "User");
    }


    function testAddLiquidity() public {
        vm.startPrank(user);

        tokenA.approve(address(app), 100 ether);
        tokenB.approve(address(app), 100 ether);

        app.addLiquidity(address(tokenA), address(tokenB), 100 ether, 100 ether, 90 ether, 90 ether, user);

        vm.stopPrank();
    }

    function testFuzzAddLiquidity(uint256 amountA, uint256 amountB) public {
    vm.assume(amountA > 0 && amountA <= 1000 ether);
    vm.assume(amountB > 0 && amountB <= 1000 ether);

    vm.startPrank(user);

    tokenA.mint(user, amountA);
    tokenB.mint(user, amountB);

    tokenA.approve(address(app), amountA);
    tokenB.approve(address(app), amountB);

    app.addLiquidity(address(tokenA), address(tokenB), amountA, amountB, 1, 1, user );

    vm.stopPrank();
}


    function testSwapTokens() public {
        vm.startPrank(user);

        uint amountIn = 100 ether;
        uint amountOutMin = 90 ether;

        // ✅ El usuario aprueba al contrato
        tokenA.approve(address(app), amountIn);

        // ✅ Mock: el router necesita balance de tokenB para hacer transfer al user
        tokenB.mint(address(router), amountOutMin);

        uint initialTokenBBalance = tokenB.balanceOf(user);

        // Ejecutamos el swap
        app.swapTokens(address(tokenA), address(tokenB), amountIn, amountOutMin, user);

        // Validamos que el usuario recibió los tokenB
        uint finalTokenBBalance = tokenB.balanceOf(user);
        assertGt(finalTokenBBalance, initialTokenBBalance, "User did not receive TokenB");

        vm.stopPrank();
    }

    function testFuzzSwapTokens(uint256 amountIn, uint256 amountOutMin) public {
        // Filtro los valores
        vm.assume(amountIn > 0 && amountIn <= 1000 ether);
        vm.assume(amountOutMin > 0 && amountOutMin <= amountIn);

        vm.startPrank(user);

        // Preparar fondos y aprobaciones
        tokenA.mint(user, amountIn);
        tokenB.mint(address(router), amountOutMin);
        tokenA.approve(address(app), amountIn);

        uint256 initialBalance = tokenB.balanceOf(user);

        app.swapTokens(address(tokenA), address(tokenB), amountIn, amountOutMin, user);

        uint256 finalBalance = tokenB.balanceOf(user);

        assertGt(finalBalance, initialBalance, "User did not receive tokenB");

        vm.stopPrank();
    }


    function testRemoveLiquidity() public {
        vm.startPrank(user);

        uint liquidity = 100 ether;

        // ✅ Usamos lpToken directamente
        lpToken.mint(user, liquidity);
        lpToken.approve(address(app), liquidity);

        uint initialTokenABalance = tokenA.balanceOf(user);
        uint initialTokenBBalance = tokenB.balanceOf(user);
        tokenA.mint(address(router), 50 ether);
        tokenB.mint(address(router), 50 ether);
        app.removeLiquidity(address(tokenA), address(tokenB), liquidity, 90 ether, 90 ether, user);

        uint finalTokenABalance = tokenA.balanceOf(user);
        uint finalTokenBBalance = tokenB.balanceOf(user);

        assertGt(finalTokenABalance, initialTokenABalance, "User did not receive TokenA");
        assertGt(finalTokenBBalance, initialTokenBBalance, "User did not receive TokenB");

        vm.stopPrank();
    }

    function testFuzzRemoveLiquidity(uint256 liquidity) public {
        vm.assume(liquidity > 10000 && liquidity <= 1000 ether);

        vm.startPrank(user);

        lpToken.mint(user, liquidity);
        lpToken.approve(address(app), liquidity);

        tokenA.mint(address(router), liquidity / 2);
        tokenB.mint(address(router), liquidity / 2);

        uint initialTokenABalance = tokenA.balanceOf(user);
        uint initialTokenBBalance = tokenB.balanceOf(user);

        app.removeLiquidity(address(tokenA), address(tokenB), liquidity, 1, 1, user);

        uint finalTokenABalance = tokenA.balanceOf(user);
        uint finalTokenBBalance = tokenB.balanceOf(user);

        assertGt(finalTokenABalance, initialTokenABalance, "User did not receive TokenA");
        assertGt(finalTokenBBalance, initialTokenBBalance, "User did not receive TokenB");

        vm.stopPrank();
    }
    
}
