import { expect } from "chai";
import { BigNumber } from "ethers";
import { ethers, deployments, getNamedAccounts } from "hardhat";

describe("StakingRewards", function () {
  beforeEach(async function () {
    await deployments.fixture(["StakingRewards"]);
  });

  it("", async function () {
    const StakingRewards = await ethers.getContract("StakingRewards");
  });
});