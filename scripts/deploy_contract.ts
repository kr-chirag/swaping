import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const getDeployFunction =
    (CONTRACT_NAME: string, CONSTRUCTOR_ARGS: any[]): DeployFunction =>
    async (hre: HardhatRuntimeEnvironment) => {
        const { deployer } = await hre.getNamedAccounts();
        const demo = await hre.deployments.deploy(CONTRACT_NAME, {
            from: deployer,
            args: CONSTRUCTOR_ARGS,
        });

        console.log(CONTRACT_NAME, "Deployed at:", demo.address, demo.newlyDeployed);
    };

export default getDeployFunction;
