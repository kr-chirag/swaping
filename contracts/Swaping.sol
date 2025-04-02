// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Swaping {
    IUniswapV2Router02 public router =
        IUniswapV2Router02(0xeE567Fe1712Faf6149d80dA1E6934E354124CfE3);
    address WETH = router.WETH();
    address USDC = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
    address EURC = 0x08210F9170F89Ab7658F0B5E3fF39b0E03C594D4;

    address[] pathWthToUSDC = [WETH, USDC];
    address[] pathUSDCToETH = [USDC, WETH];
    address[] pathEURCToUSDC = [EURC, USDC];
    address[] pathUSDCToEURC = [USDC, EURC];

    function swapExactETHForTokens() public payable {
        router.swapExactETHForTokens{value: msg.value}(
            0,
            pathWthToUSDC,
            msg.sender,
            block.timestamp + 300
        );
    }

    function swapEURCForUSDC(uint256 amount) public {
        IERC20(EURC).transferFrom(msg.sender, address(this), amount);
        IERC20(EURC).approve(address(router), amount);
        router.swapExactTokensForTokens(
            amount,
            0,
            pathEURCToUSDC,
            msg.sender,
            block.timestamp + 300
        );
    }

    function swapUSDForEURC(uint256 amount) public {
        IERC20(USDC).transferFrom(msg.sender, address(this), amount);
        IERC20(USDC).approve(address(router), amount);
        router.swapExactTokensForTokens(
            amount,
            0,
            pathUSDCToEURC,
            msg.sender,
            block.timestamp + 300
        );
    }

    function swapUSDForETH(uint256 amount) public {
        IERC20(USDC).transferFrom(msg.sender, address(this), amount);
        IERC20(USDC).approve(address(router), amount);
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
