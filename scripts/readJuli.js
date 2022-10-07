const { ethers } = require("hardhat");

async function main() {
    const MyContract = await ethers.getContractFactory("ImplementationV3");
    const contract = await MyContract.attach(
      "0x7ED94852da731A53547305B100b6F2bE5a3766ab" // The deployed contract address
    );

    console.log("Current Juli values", await contract.getJuli());
}
  
main();