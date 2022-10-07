const { ethers, upgrades } = require("hardhat");


const proxyAddress = "0x5DC1460373F0341963a01393bf0c475fC99d8209";

async function main() {
  const ImplementationV3 = await ethers.getContractFactory("ImplementationV3");
  const upgraded = await upgrades.upgradeProxy(proxyAddress, ImplementationV3);
  console.log((await upgraded.mult()).toString());
  console.log((await upgraded.newFunction()).toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });