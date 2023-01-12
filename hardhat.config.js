require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('@openzeppelin/hardhat-upgrades');
const { internalTask } = require('hardhat/config');
const { TASK_COMPILE_SOLIDITY_GET_COMPILER_INPUT } = require('hardhat/builtin-tasks/task-names');
require("dotenv").config();

internalTask(TASK_COMPILE_SOLIDITY_GET_COMPILER_INPUT, async (args, hre, runSuper) => {
  const input = await runSuper();
  input.settings.outputSelection['*']['*'].push('storageLayout');
  return input;
});

module.exports = {
  solidity: "0.8.9",
  networks: {
    ganache: {
      url: "http://127.0.0.1:8545",
      accounts: ["0x5b3208286264f409e1873e3709d3138acf47f6cc733e74a6b47a040b50472fd8", "0xae6e55ee301653982277f9031e97e7a54ee258fd617214904baf62df3047e09b"]
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_KEY
  }
};