module.exports = {
    networks: {
      dev_network: {
        host: 'localhost',
        port: 7545,
        network_id: "5777", // match any network
        gas: 4612388
      },
      ropsten: {
        host: "localhost",
        port: 8545,
        network_id: 3,
        gas: 2900000
      }
    },
    rpc: {
      host: 'localhost',
      post:8545
   }
};
