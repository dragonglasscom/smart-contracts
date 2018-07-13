var SkinsStore = artifacts.require("./SkinsStore.sol");

module.exports = function(deployer) {
  deployer.deploy(SkinsStore, "");
};
