import { ethers } from "hardhat";

export default async function main() {
    const Swaping = await ethers.getContractFactory("Swaping");
    const swaping = await Swaping.deploy();
    console.log("Deploying Swaping...");
    await swaping.waitForDeployment();
    console.log("deployed Swaping:", await swaping.getAddress());

    // await swaping.deploymentTransaction()?.wait(5) // wait 5 block transaction before verify
}
