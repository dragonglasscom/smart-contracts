var Dgs = artifacts.require("./DGS.sol");
var DgsICO = artifacts.require("./DgsICO.sol");

module.exports = function(deployer) {
    deployer.deploy(
        Dgs,
        "111111111100000000",
        "0xa5d4f3550eda8009dcd4e9d6faadd9fe797462d3",)
        .then(function() {
  return deployer.deploy(
      DgsICO,
      Dgs.address,
      "0xa5d4f3550eda8009dcd4e9d6faadd9fe797462d3");
})};
