pragma solidity ^0.5.0;

contract splitPayment {
  function send(addree payable[] memory to, uint[] memory amount) payable public{
    require(to.length == amount.length, 'to and amount arrays must have same length);
    for(uint i = 0; i < to.length; i++){
        to[i].transfer(amount[i]);
    }
  }

  modifier onlyOwner(){
    require(msg.sender == owner, 'only owner cansend transfers');
  }
}
