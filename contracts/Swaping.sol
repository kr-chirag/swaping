// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Swaping {
    IUniswapV2Router02 public router =
        IUniswapV2Router02(0xeE567Fe1712Faf6149d80dA1E6934E354124CfE3);
    address weth = router.WETH();
    address usdc = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
    address uro = 0x08210F9170F89Ab7658F0B5E3fF39b0E03C594D4;

    address[] pathWthToUSDC = [weth, usdc];
    address[] pathUSDCToETH = [usdc, weth];
    address[] pathUROToUSDC = [uro, usdc];
    address[] pathUSDCToURO = [usdc, uro];

    function swapExactETHForTokens() public payable {
        router.swapExactETHForTokens{value: msg.value}(
            0,
            pathWthToUSDC,
            msg.sender,
            block.timestamp + 300
        );
    }

    function swapUROForUSDC(uint256 amount) public {
        IERC20(uro).transferFrom(msg.sender, address(this), amount);
        IERC20(uro).approve(address(router), amount);
        router.swapExactTokensForTokens(
            amount,
            0,
            pathUROToUSDC,
            msg.sender,
            block.timestamp + 300
        );
    }

    function swapUSDForURO(uint256 amount) public {
        IERC20(usdc).transferFrom(msg.sender, address(this), amount);
        IERC20(usdc).approve(address(router), amount);
        router.swapExactTokensForTokens(
            amount,
            0,
            pathUSDCToURO,
            msg.sender,
            block.timestamp + 300
        );
    }

    function swapUSDForETH(uint256 amount) public {
        IERC20(usdc).transferFrom(msg.sender, address(this), amount);
        IERC20(usdc).approve(address(router), amount);
        router.swapExactTokensForETH(
            amount,
            0,
            pathUSDCToETH,
            msg.sender,
            block.timestamp + 300
        );
    }

    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}
