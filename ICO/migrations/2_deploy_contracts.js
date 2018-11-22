var Dgs = artifacts.require("./DGS.sol");
var DgsICO = artifacts.require("./DgsICO.sol");

const DGS_OWNER = "";
const DGS_ICO_OWNER = "";

module.exports = function(deployer) {

    if (DGS_OWNER == "" || DGS_ICO_OWNER == "") {
        console.log("[Error] No owners found!!! Please specify owners in 2_deploy_contracts.js");
        return;
    }

    deployer.deploy(Dgs, "111111111100000000", DGS_OWNER) .then(() => {
        return deployer.deploy(DgsICO, Dgs.address, DGS_ICO_OWNER);
    });
};
