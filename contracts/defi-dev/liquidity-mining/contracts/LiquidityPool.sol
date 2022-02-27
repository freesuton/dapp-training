// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

import './UnderlyingToken.sol';
import './LpToken.sol';
import './GOvernanceToken.sol';


contract LiquidityPool is LpToken {
    mapping(address => uint) public checkpoints;
    underlyingToken public underlyingToken;
    GovernanceToken public governanceToken;
    uint constant public REWARD_PER_BLOCK = 1;
    constructor(address _underlyingToken, address _governanceToken) {
        underlyingToken = UnderlyingToken(_underlyingToken);
        governanceToken = GovernanceToken(_governanceToken);
    }

    //investor can deposit their lp
    function deposit(uint amount) external {

        if(checkpoints[msg.sender] == 0){
            checkpoints[msg.sender] = block.number;
        }
        _distributeRewards(msg.sender);
        //after distribute the rewards, we need to transfer underlying token from the investor to the contract
        underlyingToken.transferFrom(msg.sender, address(this),amount);
        //mint lp token for investor
        _mint(msg.sender,amount);

    }

    function withdraw(uint amount) external {
        //make sure investor have enough token
        require(balanceOf(msg.sender) >= amount, 'not enough LP tokens');
        _distributeRewards(msg.sender);
        underlyingToken.transfer(msg.sender, amount);
        _burn(msg.sender,amount);
    }

    //if you have already deposited before, we are going to distribute sth
    function _distributeRewards(address beneficiary) internal {
        uint checkpoint = checkpoints[beneficiary];
        if(block.number - checkpoint > 0){
            //balance of LPToken
            uint distributionAmount = balanceOf(beneficiary) * (block.number - checkpoint) * REWARD_PER_BLOCK;
            //mint governance token we need
            governanceToken.mint(beneficiary,distributionAmount);
            checkpoints[beneficiary] =block.number;

        }
    }
}