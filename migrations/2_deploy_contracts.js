var DGS = artifacts.require("./DGS.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var DgsICO = artifacts.require("./DgsICO.sol");

module.exports = function(deployer) {
    deployer.deploy(DGS);
    deployer.deploy(SafeMath);
    deployer.deploy(DgsICO);
}
