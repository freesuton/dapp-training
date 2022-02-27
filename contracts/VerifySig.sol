//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract VerifySig {
    //the last input will be signature
    function verify(address _signer, string memory _message, bytes memory _sig)
     external pure returns(bool){

         //hash the message. for hashing the message we will use keccak256 and
         // hash returned by keccak 56 is bytes32
         bytes32 messageHash = getMessageHash(_message);
         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

         return recover(ethSignedMessageHash, _sig) == _signer;
    }

    function getMessageHash(string memory _message) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32) {
    return keccak256(abi.encodePacked(
        "\x19Ethereum Signed Message:\n32",
            _messageHash));
    }

    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig)
        public pure returns (address)
    {
        //split signature into 3 parts
        //parameter v is something unique to ethereum, we don't need to worry what all of
        //these parameter mean. All we need to do with these parameters is pass it to the function
        // cakked ecrecover. Pass the message which was signed 
        (bytes32 r, bytes32 s, uint8 v) = split(_sig);
        //this function returns the address of the signer given the signed message and these parameters
        return ecrecover(_ethSignedMessageHash,v,r,s);
    }

    //1._sig is a dynamic data, this is because it has a variable length
    //and for dynamic data type, the first 32 bytes stores the length of the data
    //2. _sig here is not a actual signature. it is a pointer to where the signature is
    //stored in memory
    function split(bytes memory _sig) internal pure returns(bytes32 r, bytes32 s, uint8 v){

        //make sure that the signature length is equal to 65
        //why 65? uint8 is 1 byte(8 bit = 1 byte) 32+32+1=65
        require(_sig.length == 65, "invalid signature length");
        // we will get the parameters for rsb from the signature sig
        // to do that we are gonna use assembly
        assembly{
            // we can get the value of r by typing :
            //this  will go to memory 32 bytes from the pointer that we provide into this input
            // the first 32 bytes of sig is the length of the sig. so you'll need to skip it by
            //typing add to the pointer of sig
            //from the pointer of sig, skip the first 32 byte because it holds the length of the array.
            //after we skip the first 32 bytes the value for r is stored in the next 32 bytes
            r := mload(add(_sig,32))
            //next we'll get
            s := mload(add(_sig,64))
            // skip first 32 and 64. for the value of V, we don't need 32 bytes
            //we only need the first byte. Get the first byte from the 32 bytes after 96
            v := byte(0,mload(add(_sig,96)))
        }
    }
}