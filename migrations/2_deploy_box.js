// migrations/2_deploy_TBox.js
const TBox = artifacts.require('TBox');
 
const { deployProxy } = require('@openzeppelin/truffle-upgrades');
 
module.exports = async function (deployer) {
  await deployProxy(TBox, [42], { deployer, initializer: 'store' });
};