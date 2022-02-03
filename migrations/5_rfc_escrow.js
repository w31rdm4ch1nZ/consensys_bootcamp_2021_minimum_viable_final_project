const RfCEscrow = artifacts.require("RfCEscrow");

module.exports = function (deployer) {
  deployer.deploy(RfCEscrow);
};
