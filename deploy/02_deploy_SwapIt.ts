import { ethers } from "hardhat";

export default async function main() {
    const uniswapV2Router = "0xeE567Fe1712Faf6149d80dA1E6934E354124CfE3";
    const SwapIt = await ethers.getContractFactory("SwapIt");
    const swapIt = await SwapIt.deploy(uniswapV2Router);
    console.log("Deploying SwapIt...");
    await swapIt.waitForDeployment();
    console.log("deployed SwapIt:", await swapIt.getAddress());
}
