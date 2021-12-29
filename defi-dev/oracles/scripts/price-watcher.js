const CoinGecko = require('coingecko-api');
const Oracle = artifacts.require('Oracle.sol');

const POLL_INTERVAL = 5000;
const CoinGeckoCLient = new CoinGecko();

module.exports = async done => {
  //the second address is the reporter, so we need to skip the first one
  const [_,reporter] = await web3.eth.getAccounts();
  const oracle = await Oracle.deployed();

  while(true) {
    const response = await CoinGeckoCLient.coins.fetch('bitcoin',{});
    let currentPrice = parseFloat(response.data.market_data.current_price.usd);
    //if the price of Bitcoin is 13500.7548, then the current price will be 1350075(we do so because solidity doesn't handle decimal)
    currentPrice = parseInt(currentPrice * 100);
    await oracle.updateData(
      web3.utils.soliditySha3('BTC/USD'),
        currentPrice,
        {from: reporter}
    );
    console.log(`new price for BTC/USD ${currentPrice} updated on-chain`);
    await new Promise(resolve => setTimeout(resolve, POLL_INTERVAL));
  }
  done();
}