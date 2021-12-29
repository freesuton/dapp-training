// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

//contract is ownable so the address that will deploy the contract will be the owner of contract
contract GovernanceToken is ERC20, Ownable {
    constructor() ERC20('GOvernance Token', 'GTK') Ownable(){}

    function mint(address to, uint amount) external onlyOwner(){
        _mint(to,amount);
    }
}