// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
contract Ownable{
    address payable _owner;
    
    constructor() public{
        _owner=msg.sender;
    }
    
    modifier onlyOwner(){
        require(isOwner(),"YOU ARE NOT THE OWNER");
        _;
    }
    function isOwner() public view returns(bool){
        return(msg.sender==_owner);
    }
}