module.exports = {
    networks: {
      development: {
        host: '95.85.20.19',
        port: 8080,
        network_id: "*", // match any network
        gas: 4712388,
        gasPrice: 25000000000
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
