pragma solidit ^0.5.11;

contract AssemblyEG1 {

  function foo() external {
    uint a;
    uint b;
    uint c;

    uint size;
    address addr = msg.sender;

    assembly{
    //return the size of the code at a specific eth address.
    //eath eth address has different fields associate to it. one of these field is the code field,
    // is this address is a regular address, then this field is going to be empty(0).
      size := extcodesize(addr);
  }

if(size > 0) {
return true;
}else{
return false;
}
}
}