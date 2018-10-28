module.exports = {
    networks: {
      local: {
        host: 'localhost',
        port: 8545,
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
