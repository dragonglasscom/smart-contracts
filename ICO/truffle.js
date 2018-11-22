'use strict';

var HDWalletProvider = require("truffle-hdwallet-provider");

var mnemonic = "";

module.exports = {
    networks: {
      local: {
        host: 'localhost',
        port: 9545,
        network_id: "5777",
        gas: 4612388
      },
      ropsten: {
          provider: function() {
              return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/")
          },
          network_id: 3,
          gas: 4612388
      },
      rinkeby: {
          host: 'https://rinkeby.infura.io/',
          provider: function() {
              return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/")
          },
          port: 9545,
          gas: 5000000,
          gasPrice: 5e9,
          network_id: 4
      },
      mainnet: {
          provider: function() {
              return new HDWalletProvider(mnemonic, "https://mainnet.infura.io/")
          },
          network_id: 1,
          gas: 4712388,
          gasPrice: 4000000000
      }
    }
};
