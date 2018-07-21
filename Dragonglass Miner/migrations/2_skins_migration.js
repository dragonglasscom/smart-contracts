var Witcher = artifacts.require("./skins/Witcher.sol");
var WhiteWitcher = artifacts.require("./skins/WhiteWitcher.sol");
var King = artifacts.require("./skins/King.sol");
var GlowingMushroom = artifacts.require("./skins/GlowingMushroom.sol");
var Prince = artifacts.require("./skins/Prince.sol");
var SilverPickaxe = artifacts.require("./skins/SilverPickaxe.sol");

module.exports = function(deployer) {
  //deployer.deploy(Witcher, "https://dragonglass.com/i/DMWB.png");
  //deployer.deploy(WhiteWitcher, "https://dragonglass.com/i/DMWA.png");
  //deployer.deploy(King, "https://dragonglass.com/i/DMKA.png");
  //deployer.deploy(GlowingMushroom, "https://dragonglass.com/i/DMGA.png");
  deployer.deploy(Prince, "https://dragonglass.com/i/DMPA.png");
  deployer.deploy(SilverPickaxe, "https://dragonglass.com/i/DMSA.png");
};
