import { ethers, run } from "hardhat";

export default async function main() {
    const uniswapV2Router = "0xeE567Fe1712Faf6149d80dA1E6934E354124CfE3";
    const SwapIt = await ethers.getContractFactory("SwapIt");
    const swapIt = await SwapIt.deploy(uniswapV2Router);

    // deploying contract
    console.log("Deploying SwapIt...");
    await swapIt.waitForDeployment();
    const swapItAddress = await swapIt.getAddress();
    console.log("deployed SwapIt:", swapItAddress);

    // verifying contract
    console.log("Verifying contract...");
    await swapIt.deploymentTransaction()?.wait(5); // wait 5 block transaction before verify
    try {
        await run("verify:verify", {
            address: swapItAddress,
            constructorArguments: [uniswapV2Router],
        });
    } catch (error) {
        console.log("Verification failed...");
    }
}
