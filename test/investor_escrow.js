/**
 * const InvestorEscrow = artifacts.require("InvestorEscrow");


 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript

contract("InvestorEscrow", function (accounts)  {
  it("should assert true", async function () {
    await InvestorEscrow.deployed();
    return assert.isTrue(true);
  });

  it("test get balance", async function () {
    let instance = await InvestorEscrow.deployed();
    console.log("deployed address:" +  instance.address);
    let balance = await web3.eth.getBalance(instance.address)
  });
});
**/