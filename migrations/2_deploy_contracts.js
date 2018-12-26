var SimpleStorage = artifacts.require("./SimpleStorage.sol");

var Lottery = artifacts.require("./Lottery_1.sol");

module.exports = function(deployer) {
  // deployer.deploy(SimpleStorage);
  deployer.deploy(Lottery).then ;
};
