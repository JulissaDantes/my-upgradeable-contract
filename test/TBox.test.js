// test/TBox.test.js
// Load dependencies
const { expect } = require('chai');
 
// Load compiled artifacts
const TBox = artifacts.require('TBox');
 
// Start test block
contract('TBox', function () {
  beforeEach(async function () {
    // Deploy a new TBox contract for each test
    this.TBox = await TBox.new();
  });
 
  // Test case
  it('retrieve returns a value previously stored', async function () {
    // Store a value
    await this.TBox.store(42);
 
    // Test if the returned value is the same one
    // Note that we need to use strings to compare the 256 bit integers
    expect((await this.TBox.retrieve()).toString()).to.equal('42');
  });
});