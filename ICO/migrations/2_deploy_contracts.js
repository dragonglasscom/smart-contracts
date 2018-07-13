var Dgs = artifacts.require("./DGS.sol");
var DgsICO = artifacts.require("./DgsICO.sol");

module.exports = function(deployer) {
    deployer.deploy(
        Dgs,
        "111111111100000000",
        "",)
        .then(function() {
  return deployer.deploy(
      DgsICO,
      Dgs.address,
      "");
})};
