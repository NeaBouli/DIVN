require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: "https://rpc-mumbai.matic.today",
      accounts: ["YOUR_PRIVATE_KEY"]
    }
  }
};
