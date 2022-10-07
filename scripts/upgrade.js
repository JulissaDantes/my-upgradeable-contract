const { ethers, upgrades } = require("hardhat");


const proxyAddress = "0x7ED94852da731A53547305B100b6F2bE5a3766ab";

async function main() {
  const NewImplementation = await ethers.getContractFactory("ImplementationV4");
  const upgraded = await upgrades.upgradeProxy(proxyAddress, NewImplementation);
  console.log((await upgraded.mult()).toString());
  console.log((await upgraded.newFunction()).toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });