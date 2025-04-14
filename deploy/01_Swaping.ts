import getDeployFunction from "../scripts/deploy_contract";

const CONTRACT_NAME = "Swaping";
const CONSTRUCTOR_ARGS: any[] = [];

export default getDeployFunction(CONTRACT_NAME, CONSTRUCTOR_ARGS);
export const tags = [CONTRACT_NAME];
