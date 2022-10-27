// migrations/4_prepare_upgrade_TBoxv2.js
const TBox = artifacts.require('TBox');
const TBox2 = artifacts.require('TBox2');
 
const { prepareUpgrade } = require('@openzeppelin/truffle-upgrades');
 
module.exports = async function (deployer) {
  const Tbox = await TBox.deployed();
  await prepareUpgrade(Tbox.address, TBox2, { deployer });
};