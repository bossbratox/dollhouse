const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Dollhouse", function () {

  var Dollhouse;

  beforeEach(async () => {
    [owner, stranger] = await ethers.getSigners();

    const DollhouseFactory = await ethers.getContractFactory("Dollhouse");

    Dollhouse = await DollhouseFactory.deploy(owner.address, 1000, 100);
    await Dollhouse.deployed();
  });

  it("should deploy", async () => {
    expect(await Dollhouse.name()).to.equal("Dollhouse");
    expect(await Dollhouse.symbol()).to.equal("DOLL");
  });
});
