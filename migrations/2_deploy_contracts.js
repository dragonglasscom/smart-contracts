var Dgs = artifacts.require("./DGS.sol");
var DgsICO = artifacts.require("./DgsICO.sol");

module.exports = function(deployer) {
    deployer.deploy(
        Dgs,
        "10000000000000",
        "0x9c5fc9ca3d1e775b1a4a097b3f852f062b44b377",)
        .then(function() {
  return deployer.deploy(
      DgsICO,
      Dgs.address,
      "0x9c5fc9ca3d1e775b1a4a097b3f852f062b44b377");
})};
