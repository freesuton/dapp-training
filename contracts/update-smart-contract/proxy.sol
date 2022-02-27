pragma solidity ^0.8.6;

contract Proxy {
  //these are slot address (2 memory locations, 2 arbitrary positions)
  //why these specif nums? This is actually a part of a standart for proxy called1967. this is the hash of specific string
  bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
  bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

  constructor() {
    bytes32 slot = _ADMIN_SLOT;
    address _admin = msg.sender;
    assembly {
    //the first is the memory slot, the 2nd is the value
      sstore(slot, _admin)
    }
  }

  function admin() public view returns (address adm) {
    bytes32 slot = _ADMIN_SLOT;
    assembly {
    //read value from the storage you passed it to memory slot
      adm := sload(slot)
    }
  }

  function implementation() public view returns (address impl) {
    bytes32 slot = _IMPLEMENTATION_SLOT;
    assembly {
      impl := sload(slot)
    }
  }

  //call it when you want to change the implementation
  function upgrade(address newImplementation) external {
    require(msg.sender == admin(), 'admin only');
    bytes32 slot = _IMPLEMENTATION_SLOT;
    assembly {
      sstore(slot, newImplementation)
    }
  }

  fallback() external payable {
    assembly {
    //first we are going to retrieve the address of the implementation
    //sload allow you load some data from the storage
      let _target := sload(_IMPLEMENTATION_SLOT)
    //copy s bytes from calldata at position f to mem at position t.
    //copy the function call to memory. we give it the first memory slot where we want to copy it to
      calldatacopy(0x0, 0x0, calldatasize())
    //use delegate called opcode and the 1st argument is how much gas we forward to this call.
    //gas() is a built-in function of assembly.
    //2nd argument is the address of the implementation.
    //3rd which function we want to call and with which argument(for that we are going to read from memory),
    //Remember that we copied calldata into memory, we are going to start from the first slot in memory and then use calldatasize()
    //- to know where the calldata ends.
    //Last 2 arguments: where we want to start in storage of the proxy,
    //because with delegatecall, we are going to call our implementation smart contract,
    //but any modification of the state will actually be done in our smart proxy contract.
    //And after we're gonna have a boolean value depending on whether these calls succeeded or not
      let result := delegatecall(gas(), _target, 0x0, calldatasize(), 0x0, 0)
    //Use another built-in function return data copy in order to copy the written data and return it from the fallback function.
    //So all of this is the quivalent of return in solidity
    // And use returndatacopy() to copy any data that was returned by previous function call and we're
    //gonna copy this in memory
    // returndatasize() : know the size of return data.
    // returndatacopy(): to copy data that was returned by previous function call and copy this in memory
      returndatacopy(0x0, 0x0, returndatasize())
    //result == 0 means fail, otherwise return the data returned by our function call. it will read from the first slot(0)
    //returndatasize() know the size of the written data
      switch result case 0 {revert(0, 0)} default {return (0, returndatasize())}
    }
  }
}