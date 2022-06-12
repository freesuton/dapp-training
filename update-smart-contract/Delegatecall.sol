// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// NOTE: Deploy this contract first
contract B {
  // NOTE: storage layout must be the same as contract A
  uint public num;
  address public sender;
  uint public value;

  function setVars(uint _num) public payable {
    num = _num;
    sender = msg.sender;
    value = msg.value;
  }
}

contract B2 {
  // NOTE: storage layout must be the same as contract A
  uint public num;
  address public sender;
  uint public value;

  function setVars(uint _num) public payable {
    num = 2 * _num;
    sender = msg.sender;
    value = msg.value;
  }
}

contract A {
  uint public num;
  address public sender;
  uint public value;

  function setVars(address _contract, uint _num) public payable {
    // A's storage is set, B is not modified.
    //delegatecall returns 2 outputs. it return success if the function executed without any errors
    (bool success, bytes memory data) = _contract.delegatecall(
      abi.encodeWithSignature("setVars(uint256)", _num)
    );
  }
}