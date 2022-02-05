/*

  REMEMBER: A web3 instance is available in each test file, 
  configured to the correct provider. So calling web3.eth.getBalance just works!

*/

const FundsManager = artifacts.require("FundsManager");



contract("FundsManager", function (accounts) {

  
  // beforeEach(async () => {
  //   fmInstance = await FundsManager.new(FundsManager.address);
  //   RequestForContent = await RequestForContent.new(FundsManager.address);
  //   const fmInstance = FundsManager.deployed();
  //   return assert.isTrue(true);
  // });

  it("should assert true", async function () {
    await FundsManager.deployed();
    return assert.isTrue(true);
  });

  //var fmInstance = FundsManager.new(FundsManager.address);
  
  it("should return the list of accounts", async ()=> {
    console.log(accounts);
  });

  it ("Contract funds should be initiated at 0. eth == 0", async () => {
    fmInstance = await FundsManager.new();
    // verify balance of contract is 0 at first:
    const contractInitialBalance = await fmInstance.getContractBalance.call();
    console.log(contractInitialBalance);
    assert.equal(contractInitialBalance, 0, "Initial state/balance should be 0");

  });

  describe("Functionality", () => {

    //check contract balance:
    it ("should get the current contract balance", async () => {
      fmInstance = await FundsManager.new();
      const contractBal = await fmInstance.getBalance();
      console.log(contractBal);  
      fmInstance.getBalance.call();
    })

    it("The contract should receive ether correctly", async () => {
      fmInstance = await FundsManager.new();
      // Get initial balances of first and contract account.
      var account_one = accounts[0];
      //var account_two = accounts[1];
      var contract_account = fmInstance.options.address;

      var account_one_starting_balance;
      var contract_account_starting_balance;
      var account_one_ending_balance;
      var contract_account_ending_balance;

      console.log("that's 1st account",account_one);
      console.log("that should be the FM contract address",contract_account);

      fmInstance.safeDepositForMembership.call(account_one);

      web3.eth.sendTransaction({
          from: account_one,
          to: contract_account,
          value: '1000000000000000'
      })
      .then(function(){
          return fmInstance.getContractBalance.call();
      // }).then(function(balance) {
      //     account_one_ending_balance = balance.toNumber();
      //     contract_account_ending_balance = balanceOf().toNumber();

      //     fmInstance.getContractBalance.call().then.console.log(contractBal);
      //     //make sure the sender is taken the ether sent to the contract
      //     assert.equal(account_one_ending_balance, account_one - 1000000000000000, "Amount wasn't correctly taken from the sender");
      //     // make sure the contract receives the amount sent (maybe -gas => could lead to an error, it it happens check that)
      //     assert.equal(account_contract_ending_balance, 1000000000000000, "1000000000000000 is not in the contract.");
      });
    });

    //should evolve to test that the contract receive and
  //   it ("should have a new balance of 3", async () => {

  //   await fmInstance.setContractBalance(3, {from: accounts[0]});
    
  //   const newContractBalance = await fmInstance.getContractBalance.call();

  //   assert.equal(newContractBalance, 1, `3 was not added`)
  //   })
  });

  
});