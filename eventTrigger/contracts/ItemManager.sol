// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import"./Ownable.sol";
import"./Item.sol";
contract ItemManager is Ownable{
    enum SupplyChainState{Created,Paid,Delivered}
    struct S_Item{
        Item _item;
        string _idetifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }
    mapping(uint => S_Item)public items;
    uint itemIndex;
    
    event SupplyChainStep(uint _itemIndex, uint _step,address _itemAddress);
    
    function createItem(string memory _idetifier, uint _itemPrice)public onlyOwner{
        Item item = new Item(this,_itemPrice,itemIndex);
        items[itemIndex]._item=item;
        items[itemIndex]._idetifier=_idetifier;
        items[itemIndex]._itemPrice=_itemPrice;
        items[itemIndex]._state=SupplyChainState.Created;
        emit SupplyChainStep(itemIndex,uint(items[itemIndex]._state),address (item));
        itemIndex++;
    }
    function triggerPayment(uint _index) public payable{
        Item item = items[_index]._item;
      require(address(item) == msg.sender, "Only items are allowed to update themselves");
    require(item.priceInWei() == msg.value, "Not fully paid yet");
    require(items[_index]._state == SupplyChainState.Created, "Item is further in the supply chain");
     items[_index]._state = SupplyChainState.Paid;
     emit SupplyChainStep(_index, uint(items[_index]._state), address(item));
 }
    function triggerDelivery(uint _itemIndex) public onlyOwner{
        require(items[_itemIndex]._state==SupplyChainState.Paid,"Item is to be paid for");
        items[_itemIndex]._state=SupplyChainState.Delivered;
        
        emit SupplyChainStep(_itemIndex,uint(items[_itemIndex]._state),address(items[_itemIndex]._item));
    }
    
}