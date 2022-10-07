const { ethers, upgrades } = require("hardhat");

async function main() {
  const ImplementationV1 = await ethers.getContractFactory("ImplementationV3");
  const proxy = await upgrades.deployProxy(ImplementationV1, [12, 12]);
  await proxy.deployed();
  console.log(await upgrades.erc1967.getImplementationAddress(proxy.address)," getImplementationAddress")
  console.log(proxy.address, "Proxy address");
}

main();