var Dgs = artifacts.require("./DGS.sol");
var DgsICO = artifacts.require("./DgsICO.sol");

module.exports = function(deployer) {
    deployer.deploy(
        Dgs,
        "10000000000000",
        "0x4a032c702bee4ff196809f8f47b8434a45cc7571",)
        .then(function() {
  return deployer.deploy(
      DgsICO,
      Dgs.address,
      "0x4a032c702bee4ff196809f8f47b8434a45cc7571");
})};
