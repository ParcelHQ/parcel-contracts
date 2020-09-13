usePlugin("@nomiclabs/buidler-waffle");

// This is a sample Buidler task. To learn how to create your own go to
// https://buidler.dev/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(await account.getAddress());
  }
});

// You have to export an object to set up your config
// This object can have the following optional entries:
// defaultNetwork, networks, solc, and paths.
// Go to https://buidler.dev/config/ to learn more
module.exports = {
  // This is a sample solc configuration that specifies which version of solc to use
  solc: {
    version: "0.6.8",
    optimizer: {
      enabled: true,
      runs: 200
    }
  }, defaultNetwork: "rinkeby",
  networks: {
    buidlerevm: {
    },
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/ba2cbfce98d247acbe90f05788d9de33",
      accounts: ["0x6dd1098834f282f6e2d107a94a33ef944e8d9177c03ca38f6bde4b577aa35799"]

      // public address : 0x70bA22c09EC3fb962E0b3197d212E302b466f270
    }
  }
};
