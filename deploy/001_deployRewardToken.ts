import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployRewardToken: DeployFunction = async function (
  hre: HardhatRuntimeEnvironment
) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy("ST_GEToken", {
    from: deployer,
    log: true,
  });
};
export default deployRewardToken;
deployRewardToken.tags = ["ST_GEToken"];
