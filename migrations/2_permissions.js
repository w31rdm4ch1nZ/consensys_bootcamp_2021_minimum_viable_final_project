var Permissions = artifacts.require("./Permissions.sol");
var IPermissions = artifacts.require("./IPersmissions.sol");
var IPermissionsRead = artifacts.require("./IPermissionsRead.sol");

module.exports = function(deployer) {
  deployer.deploy(Permissions);
  deployer.deploy(IPermissions);
  deployer.deploy(IPermissionsRead);
};
