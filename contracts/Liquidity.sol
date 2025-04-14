// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Liquidity {
    using SafeERC20 for IERC20;
    IUniswapV2Router02 private router;
    IUniswapV2Factory private factory;

    address private USDC = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
    address private WETH = 0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14;
    address[] private path = [USDC, WETH];

    IUniswapV2Pair private pair;

    constructor(address _uniswapV2Router, address _uniswapV2Factory) {
        router = IUniswapV2Router02(_uniswapV2Router);
        factory = IUniswapV2Factory(_uniswapV2Factory);
        pair = IUniswapV2Pair(factory.getPair(USDC, WETH));
    }

    function addLiquidity(
        uint256 amountUSDC,
        uint256 amountEURC,
        uint256 slippageRate
    ) public {
        IERC20(USDC).safeTransferFrom(msg.sender, address(this), amountUSDC);
        IERC20(WETH).safeTransferFrom(msg.sender, address(this), amountEURC);
        IERC20(USDC).approve(address(router), amountUSDC);
        IERC20(WETH).approve(address(router), amountEURC);
        uint amountUSDCMin = applySlippage(amountUSDC, slippageRate);
        uint amountEURCMin = applySlippage(amountEURC, slippageRate);
        router.addLiquidity(
            USDC,
            WETH,
            amountUSDC,
            amountEURC,
            amountUSDCMin,
            amountEURCMin,
            msg.sender,
            block.timestamp + 300
        );
    }

    function removeLiquidity(uint256 slippageRate) public returns (uint, uint) {
        (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
        uint256 liquidity = getLiquidityBalance();
        uint256 totalSupply = pair.totalSupply();

        uint256 amountUSDC = (liquidity * reserve0) / totalSupply;
        uint256 amountEURC = (liquidity * reserve1) / totalSupply;

        uint256 amountUSDCMin = applySlippage(amountUSDC, slippageRate);
        uint256 amountEURCMin = applySlippage(amountEURC, slippageRate);

        IERC20(address(pair)).approve(address(router), liquidity);

        return
            router.removeLiquidity(
                USDC,
                WETH,
                liquidity,
                amountUSDCMin,
                amountEURCMin,
                msg.sender,
                block.timestamp + 300
            );
    }

    function getLiquidityBalance() public view returns (uint256) {
        return IERC20(address(pair)).balanceOf(msg.sender);
    }

    function applySlippage(
        uint amountDesired,
        uint slippageRate
    ) public pure returns (uint) {
        return amountDesired - ((amountDesired * slippageRate) / 100);
    }

    function getAmountsOut(
        uint amountIn
    ) public view returns (uint[] memory amounts) {
        return router.getAmountsIn(amountIn, path);
    }
}
