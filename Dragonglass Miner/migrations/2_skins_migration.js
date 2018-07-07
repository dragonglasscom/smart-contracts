var Witcher = artifacts.require("./skins/Witcher.sol");

module.exports = function(deployer) {
  deployer.deploy(Witcher, "");
};
