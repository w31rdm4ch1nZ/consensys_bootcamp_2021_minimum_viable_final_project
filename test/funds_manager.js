const FundsManager = artifacts.require("FundsManager");
const RequestForContent = artifacts.require("RequestForContent");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("FundsManager", function (accounts) {
    beforeEach(async () => {
      FundsManager = await FundsManagerFactory.new(FundsManager.address);
      RequestForContent = await RequestForContentFactory.new(FundsManager.address);
    });
    return assert.isTrue(true);
  });

  it ("funds should be initiated at 0. eth == 0", async () => {
    // get contract deployed
    const fmInstance = await FundsManager.deployed();

    // verify balance of contract is 0 at first:
    const contractInitialBalance = await fmInstance.getContractBalance.call();
    assert.equal(contractInitialBalance, 0, "Initial state/balance should be 0");

  })

  describe("Functionality", () => {

    //check contract balance:
    it ("should get the current contract balance", async () => {
      // get contract address of the instance deployed
      const fmInstance = await FundsManager.deployed();

      const contractBal = await fmInstance.getContractBalance();
      
      fmInstance.getContractBalance.call().then.console.log(contractBal);
    })

    //should evolve to test that the contract receive and
    it ("should have a new balance of 3", async () => {
    // get contract address of the instance deployed
    const fmInstance = await FundsManager.deployed();

    await fmInstance.setContractBalance(3, {from: accounts[0]});
    
    // change the balance in the constructor (next will be after a tx send)
    const newContractBalance = await fmInstance.getContractBalance.call();

    assert.equal(newContractBalance, 3, `3 was not added`)
    })
  })


});
