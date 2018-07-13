var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "";

module.exports = {
    networks: {
      dev_network: {
        host: 'localhost',
        port: 7545,
        network_id: "5777",
        gas: 4612388
      },
      dragonglass_blockchain: {
          host: '188.166.79.218',
          port: 8545,
          network_id: "*", // match any network
          gas: 4612388
      },
      ropsten: {
          provider: function() {
              return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/")
          },
          network_id: 3,
          gas: 4612388
      }
    },
    rpc: {
      host: 'localhost',
      post:8545
   }
};
