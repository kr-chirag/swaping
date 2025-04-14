import getDeployFunction from "../scripts/deploy_contract";

const CONTRACT_NAME = "SwapIt";
const CONSTRUCTOR_ARGS: any[] = ["0xeE567Fe1712Faf6149d80dA1E6934E354124CfE3"];

export default getDeployFunction(CONTRACT_NAME, CONSTRUCTOR_ARGS);
export const tags = [CONTRACT_NAME];
