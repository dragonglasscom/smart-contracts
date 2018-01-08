var dgsToken = artifacts.require("./DGS.sol");
var ico = artifacts.require("./DgsICO.sol");

contract('DgsTokenTest', function(accounts) {
    let founder1, founder2, client1, client2;

    before(async () => {
        founder1 = web3.eth.accounts[0];
        founder2 = web3.eth.accounts[1];
        client1 = web3.eth.accounts[2];
        client2 = web3.eth.accounts[3];
    });

    it("should assert true", function(done) {
        var dgs_token_test = dgsToken.deployed();
        assert.isTrue(true);
        console.log("hi!");
        done();
    });
});
