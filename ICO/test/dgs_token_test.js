var dgsToken = artifacts.require("./DGS.sol");
var ico = artifacts.require("./DgsICO.sol");

contract('DgsTokenTest', function(accounts) {
    let instance;

    before(async function() {
      instance = await dgsToken.deployed();
    })

    it("returns correct amount for balanced transaction",
      async function() {
        let stakeAmount = 5000000000, sentAmount = 5000000000;
        let expected = 2589254100;

        let minedAmount =
          (await instance.calculateMinedCoinsForTX.call(stakeAmount, sentAmount))
          .toNumber();

        assert.equal(minedAmount,
          expected,
          "Incorrect number of tokens mined when kept amount and sent amount are equal");
      })

    it("returns correct amount for transactions where left amount dominates",
      async function() {
        let stakeAmount = 7500000000, sentAmount = 2500000000;
        let expected = 863084691;

        let minedAmount =
          (await instance.calculateMinedCoinsForTX.call(stakeAmount, sentAmount))
          .toNumber();

        assert.equal(minedAmount,
          expected,
          "Incorrect number of tokens mined when kept amount is greater than sent");
      })

    it("returns correct amount for transactions where sent amount dominates",
      async function() {
        let stakeAmount = 2500000000, sentAmount = 7500000000;
        let expected = 906238909;

        let minedAmount =
          (await instance.calculateMinedCoinsForTX.call(stakeAmount, sentAmount))
          .toNumber();

        assert.equal(minedAmount,
          expected,
          "Incorrect number of tokens mined when sent amount is greater than kept");
      })
});
