pragma solidity ^0.5.11;


//cast bytes to bytes32
contract AssemblyEG2 {

  function foo() external {
    uint a;
    uint b;
    uint c;

    bytes memory data = new bytes(10);

    // it is not working out side of assembly on 0.5.0
    // bytes32 dataB32 = bytes32(data);

    bytes32 dataB32;

    assembly{
    //data is a pointer so data is gonna be address of out bytes
    //but it not wokrs because in memory the first memory slot actually is the size of the byte,
    //data actuall start from second slot
    // operation of adding 32bytes to this ponter and mload is going to read from the correct memory location
      dataB32 := mload(add(data,32))
    }
  }
}