import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployStakingRewards: DeployFunction = async function (
  hre: HardhatRuntimeEnvironment
) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy, get, execute } = deployments;
  const { deployer } = await getNamedAccounts();
  const stakingToken = await get("GEToken");
  const rewardToken = await get("ST_GEToken");
  await deploy("StakingRewards", {
    from: deployer,
    log: true,
  });
  await execute(
    "StakingRewards",
    { from: deployer },
    "initialize",
    stakingToken.address,
    rewardToken.address,
    100
  );
};
export default deployStakingRewards;
deployStakingRewards.tags = ["StakingRewards"];
