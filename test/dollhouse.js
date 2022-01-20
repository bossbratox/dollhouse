// const { expect } = require("chai");
// const { ethers } = require("hardhat");

// describe("Dollhouse", function () {

//   var Dollhouse;

//   beforeEach(async () => {
//     [owner, stranger] = await ethers.getSigners();
//     const DollhouseFactory = await ethers.getContractFactory("Dollhouse");
//     Dollhouse = await DollhouseFactory.deploy(owner.address, 1000, 100);
//     await Dollhouse.deployed();
//   });

//   it("should deploy", async () => {
//     expect(await Dollhouse.name()).to.equal("Dollhouse");
//     expect(await Dollhouse.symbol()).to.equal("DOLL");
//   });

//   it("disallows minting by non-admins when public sale is not open", async () => {
//     await expect(Dollhouse.connect(stranger).mint(1, {
//       value: ethers.utils.parseEther("0.01")
//     })).to.be.revertedWith("Public sale is not open");    
//   });

//   it("disallows minting by non-admins when insufficient amount is sent", async () => {
//     await Dollhouse.setIsPublicSaleActive(true);
    
//     await expect(Dollhouse.connect(stranger).mint(1, {
//       value: ethers.utils.parseEther("0.001")
//     })).to.be.revertedWith("Incorrect ETH value sent");    
//   });

//   // NOTE: not sure why they don't accommodate over-sending and refund the excess?
//   it("disallows minting by non-admins when too much eth is sent", async () => {
//     await Dollhouse.setIsPublicSaleActive(true);   

//     await expect(Dollhouse.connect(stranger).mint(1, {
//       value: ethers.utils.parseEther("10.00")
//     })).to.be.revertedWith("Incorrect ETH value sent");    
//   });

//   it("allows minting one token during public sale", async () => {
//     await Dollhouse.setIsPublicSaleActive(true);    
//     var tx = await Dollhouse.connect(stranger).mint(1, {
//       value: ethers.utils.parseEther("0.01")
//     });
//     expect(tx).to.emit(Dollhouse, "Transfer").withArgs("0x0000000000000000000000000000000000000000", stranger.address, "0x01");
//   });

//   it("allows reserving (minting) one doll to owner address when public sale is closed", async () => {       
//     var tx = await Dollhouse.connect(owner).reserveForGifting(1);
//     expect(tx).to.emit(Dollhouse, "Transfer").withArgs("0x0000000000000000000000000000000000000000", owner.address, "0x01");
//   });

//   it("disallows reserving with non-admin account", async () => {       
//     await expect(Dollhouse.connect(stranger).reserveForGifting(1)).to.be.revertedWith("Ownable: caller is not the owner");
//   });

//   it("disallows reserving past max gifted dolls limit", async () => {       
//     await expect(Dollhouse.connect(owner).reserveForGifting(101)).to.be.revertedWith("Not enough dolls remaining to gift");
//   });

//   it("can reserve max dolls", async () => {       
//     await Dollhouse.connect(owner).reserveForGifting(100);
//   });

// });
