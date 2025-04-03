// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract SwapIt is Ownable {
    IUniswapV2Router02 private router;
    address[] public tokens;
    uint256 public feeRate = 950;

    constructor(address _uniswapV2Router) Ownable(msg.sender) {
        router = IUniswapV2Router02(_uniswapV2Router);
    }

    function setRouter(address _uniswapV2Router) public onlyOwner {
        router = IUniswapV2Router02(_uniswapV2Router);
    }

    function setFeeRate(uint256 _feeRate) public onlyOwner {
        require(_feeRate > 0 && _feeRate < 1000, "INVALID FEE RATE");
        feeRate = _feeRate;
    }

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) internal pure returns (uint256 amountB) {
        require(amountA > 0, "INSUFFICIENT AMOUNT");
        require(reserveA > 0 && reserveB > 0, "INSUFFICIENT LIQUIDITY");
        amountB = (amountA * reserveB) / reserveA;
    }

    function getAmountsOut(
        uint256 amountIn,
        address[] memory path
    ) public view returns (uint256) {
        uint256 amountIn2 = (amountIn * feeRate) / 1000;
        uint256[] memory amounts = router.getAmountsOut(amountIn2, path);
        return amounts[amounts.length - 1];
    }

    function getAmountsIn(
        uint256 amountOut,
        address[] memory path
    ) public view returns (uint256) {
        uint256[] memory amounts = router.getAmountsIn(amountOut, path);
        return amounts[amounts.length - 1];
    }

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external {
        tokens.push(path[0]);
        IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn);
        uint256 amountIn2 = (amountIn * feeRate) / 1000;
        IERC20(path[0]).approve(address(router), amountIn2);
        router.swapExactTokensForTokens(
            amountIn2,
            amountOutMin,
            path,
            to,
            deadline
        );
    }

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external {
        tokens.push(path[0]);
        IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn);
        uint256 amountIn2 = (amountIn * feeRate) / 1000;
        IERC20(path[0]).approve(address(router), amountIn2);
        router.swapExactTokensForETH(
            amountIn2,
            amountOutMin,
            path,
            to,
            deadline
        );
    }

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable {
        uint256 eth = (msg.value * feeRate) / 1000;
        router.swapExactETHForTokens{value: eth}(
            amountOutMin,
            path,
            to,
            deadline
        );
    }

    function withdrawAll() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
        for (uint256 i; i < tokens.length; i++) {
            IERC20 token = IERC20(tokens[i]);
            token.transfer(owner(), token.balanceOf(address(this)));
        }
    }
}
