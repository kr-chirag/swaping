import getDeployFunction from "../scripts/deploy_contract";

const ROUTER = "0xeE567Fe1712Faf6149d80dA1E6934E354124CfE3";
const FACTORY = "0xF62c03E08ada871A0bEb309762E260a7a6a880E6";

const CONTRACT_NAME = "Liquidity";
const CONSTRUCTOR_ARGS: any[] = [ROUTER, FACTORY];

export default getDeployFunction(CONTRACT_NAME, CONSTRUCTOR_ARGS);
export const tags = [CONTRACT_NAME];
