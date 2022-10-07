const { expect } = require('chai');

const Proxy = artifacts.require('Proxy');
const Loanv1 = artifacts.require('Loanv1');

contract('ERC20',async function (accounts) {
    let owner, user1,user2;
    before(async function () {
        [ owner, user1, user2 ] = accounts;
        this.loan = await Loanv1.new({ from: owner });
        this.proxy = await Proxy.new(this.loan.address, '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266', { from: owner });
        await this.proxy.transferOwnership(owner,{ from: owner });
    });

    it('has a interest rate', async function () {
        console.log(owner, await this.proxy.owner());
        await this.proxy.changeInterestRate(18, { from: owner });
        console.log(Number(await this.loan.getRate()));
        expect(await this.loan.getRate()).to.be.bignumber.equal(0);
      });
});