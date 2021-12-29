// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

import './IOracle.sol';

contract Consumer {
    IOracle public oracle;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
    }

    //example function which will fetch data
    function foo() external {
        //we need to compiute the key of data we want
        //use a hash function of solidity
        //keccak256 needs a byte value as input and abi.encodePacked will produce byte
        bytes32 key = keccak256(abi.encodePacked('BTC/USD'));

        (bool result, uint timestamp, uint data) = oracle.getData(key);
        require(result == true, 'could not get price');
        require(timestamp >= block.timestamp - 2 minutes,'price too old');
        //do something with price
    }
}