var SkinsStore = artifacts.require("./SkinsStore.sol");

module.exports = function(deployer) {
  deployer.deploy(SkinsStore, "0x6aEDbF8dFF31437220dF351950Ba2a3362168d1b");
};
