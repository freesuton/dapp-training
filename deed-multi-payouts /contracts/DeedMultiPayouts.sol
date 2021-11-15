pragma solidity ^0.5.0;

contract DeedMultiPayout {
  address public lawyer;
  address payable public beneficiary;
  uint public earliest;
  //everypayment
  uint public amount;
  //number of payouts
  uint constant public PAYOUTS = 10;
  uint constant public INTERVAL = 10;
  //nums of paid 
  uint public paidPayouts;
  
  constructor(
    address _lawyer,
    address payable _beneficiary,
    uint fromNow)
    payable
    public {
        lawyer = _lawyer;
        beneficiary = _beneficiary;
        earliest = now + fromNow;
        amount = msg.value / PAYOUTS;
    }
  
  function withdraw() public {
    require(msg.sender == beneficiary, 'beneficiary only');
    require(now >= earliest, 'too early');
    require(paidPayouts < PAYOUTS, 'no payout left');
    
    uint elligiblePayouts = (now - earliest) / INTERVAL;
    //the num of paidouts of this call
    uint duePayouts = elligiblePayouts - paidPayouts;
    duePayouts = duePayouts + paidPayouts > PAYOUTS ? PAYOUTS - paidPayouts : duePayouts;
    paidPayouts += duePayouts;
    beneficiary.transfer(duePayouts * amount);
  }
}
