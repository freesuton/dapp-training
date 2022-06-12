const Oracle = artifacts.require("Oracle.sol");
const Consumer = artifacts.require("Consumer.sol");

module.exports = async function (deployer, _network, address) {
  // _ means ignore the rest
  const [admin, reporter,_] = address;
  await deployer.deploy(Oracle,admin);
  const oracle = await Oracle.deployed();
  await oracle.updateReporter(reporter,true);
  await deployer.deploy(Consumer, oracle.address);
};
