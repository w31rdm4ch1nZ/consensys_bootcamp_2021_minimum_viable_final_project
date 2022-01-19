const RequestForContent = artifacts.require("RequestForContent");

module.exports = function (deployer) {
  deployer.deploy(RequestForContent);
};