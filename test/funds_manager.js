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

  });

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
  });

  var InvestorEscrow = artifacts.require(".DeFiMarketMakerLogic/InvestorEscrow");

contract('InvestorEscrow', function(accounts) {

    const [contractOwner, alice] = accounts;
    //toBN => to big numer; 2 is for 2 accounts (?)
    const deposit = web3.utils.toBN(2);
  
    beforeEach(async () => {
      instance = await InvestorEscrow.new();
    });

    it("The contract should receive ether correctly", function() {
        // Get initial balances of first and second account.
        var account_one = accounts[0];
        //var account_two = accounts[1];
        var contract_account = FundsManager.options.address;

        web3.eth.sendTransaction({
            from: account_one,
            to: contract_account,
            value: '1000000000000000'
        })
        .then(function(instance){
            return instance.getBalance.call(contract_account);
        }).then(function(balance) {
            account_one_ending_balance = balance.toNumber();
            contract_account_ending_balance = balanceOf().toNumber();
            //make sure the sender is taken the ether sent to the contract
            assert.equal(account_one_ending_balance, account_one - 1000000000000000, "Amount wasn't correctly taken from the sender");
            // make sure the contract receives the amount sent (maybe -gas => could lead to an error, it it happens check that)
            //assert.equal(account_contract_ending_balance, 1000000000000000, "1000000000000000 is not in the contract.");
        });
    });


});


});
