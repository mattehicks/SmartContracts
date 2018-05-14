module.exports = {
    networks: {
        development: {
            host: "0.0.0.0",
            port: 7545,
            network_id: "*" // Match any network id
        },
        ourTestNet: {
            host: "0.0.0.0",
            port: 8545,
            network_id: "*",
            gas: 4600000
        }
    }
};