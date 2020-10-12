// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import"./ItemManager.sol";
contract Item{
    uint public priceInWei;
    uint public index;
    uint public pricePaid;
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract , uint _priceInWei, uint _index) public
    {
        priceInWei=_priceInWei;
        index=_index;
        parentContract=_parentContract;
    }
    
    receive()external payable
    {
        require(pricePaid==0,"Item is already paid ");
        require(priceInWei==msg.value,"Only full payment accepted");
        pricePaid+=msg.value;
       (bool success, ) =address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)",index));
        require(success,"The transation wasn't successful , cancelling");
        
    }
    fallback()external{
        
    }
}