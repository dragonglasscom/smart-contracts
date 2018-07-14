var Witcher = artifacts.require("./skins/Witcher.sol");
var WhiteWitcher = artifacts.require("./skins/WhiteWitcher.sol");
var King = artifacts.require("./skins/King.sol");
var GlowingMushroom = artifacts.require("./skins/GlowingMushroom.sol");
var Prince = artifacts.require("./skins/Prince.sol");
var SilverPickaxe = artifacts.require("./skins/SilverPickaxe.sol");

module.exports = function(deployer) {
  deployer.deploy(Witcher, "");
  deployer.deploy(WhiteWitcher, "");
  deployer.deploy(Kind, "");
  deployer.deploy(GlowingMushroom, "");
  deployer.deploy(Prince, "");
  deployer.deploy(SilverPickaxe, "");
};
