const MembershipNFT = artifacts.require("MembershipNFT");

module.exports = function (deployer) {
  deployer.deploy(MembershipNFT);
};