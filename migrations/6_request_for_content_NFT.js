const RequestForContentNFT = artifacts.require("RequestForContentNFT");

module.exports = function (deployer) {
  deployer.deploy(RequestForContentNFT);
};