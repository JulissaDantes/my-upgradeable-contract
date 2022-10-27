// test/TBox.proxy.test.js
// Load dependencies
const { expect } = require('chai');
const { deployProxy } = require('@openzeppelin/truffle-upgrades');
 
// Load compiled artifacts
const TBox = artifacts.require('TBox');
 
// Start test block
contract('TBox (proxy)', function () {
  beforeEach(async function () {
    // Deploy a new TBox contract for each test
    this.TBox = await deployProxy(TBox, [42], {initializer: 'store'});
  });
 
  // Test case
  it('retrieve returns a value previously initialized', async function () {
    // Test if the returned value is the same one
    // Note that we need to use strings to compare the 256 bit integers
    expect((await this.TBox.retrieve()).toString()).to.equal('42');
  });
});