pragma solidit ^0.5.11;

contract A {

  function foo() external {
    //When we manipulate simple data types like uint, it occupies a single slot.
    //Like slot 1, slot 2, slot3
    uint a;
    uint b;
    uint c;

    c = a + b;

    assembly{
      c := add(1,2);
  }

//specify the address that you want to load
//this address will return you the address of the next available slot for memory
//if you don't allocate some space for an array for example: you will need to access this special address
//then you are gonna to assign this to a variable
let a := mload(0x40)
// if you want to store something to memory ,then use mstore
// first argument is the address of the destination,
//second is payload( what we want to actually store,can be 1 can be2)
//the payload must fit in 256 bits
//third: if you want to store to the storage so something that will be persistent inside the blockcahin

mstore(a, 2);
//then you need to use "sstore" key word (argument is the same)

sstore(a,10);

}
}
}