const FundsManager = artifacts.require("FundsManager");

module.exports = function (deployer) {
  deployer.deploy(FundsManager);
};
