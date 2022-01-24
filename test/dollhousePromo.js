const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DollhousePromo", function () {

  var DollhousePromo;

  beforeEach(async () => {
    [owner, stranger] = await ethers.getSigners();
    const DollhousePromoFactory = await ethers.getContractFactory("DollhousePromo");
    DollhousePromo = await DollhousePromoFactory.deploy(1000, 100);
    await DollhousePromo.deployed();
  });

  it("should deploy", async () => {
    expect(await DollhousePromo.name()).to.equal("Dollhouse Promo");
    expect(await DollhousePromo.symbol()).to.equal("DOLLPROMO");
  });

  it("should not allow non-owner mints", async () => {
    expect(await DollhousePromo.name()).to.equal("Dollhouse Promo");
    expect(await DollhousePromo.symbol()).to.equal("DOLLPROMO");
  });
});