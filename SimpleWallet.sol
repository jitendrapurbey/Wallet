pragma solidity ^0.4.19;

contract mortal is owned {
    function kill() public {
        if (msg.sender == owner)
            selfdestruct(owner);
    }

contract SimpleWallet is mortal {
    
    mapping(address => Permission) permittedAddresses;
    
    event someoneAddedSomeoneToTheSendersList(address thePersonWhoAdded, address thePersonWhoIsAllowedNow, uint thisMuchHeCanSend);
  
    struct Permission {
        bool isAllowed;
        uint maxTransferAmount;
    }
    
    function addAddressToSendersList(address permitted, uint maxTransferAmount) public onlyowner {
        permittedAddresses[permitted] = Permission(true, maxTransferAmount);
        someoneAddedSomeoneToTheSendersList(msg.sender, permitted, maxTransferAmount);
    }
    
    function sendFunds(address receiver, uint amountInWei) public {
        require(permittedAddresses[msg.sender].isAllowed);
        require(permittedAddresses[msg.sender].maxTransferAmount >= amountInWei);
        
        bool isTheAmountReallySent = receiver.send(amountInWei);
        require(isTheAmountReallySent == true);
    }
    
    function removeAddressFromSendersList(address theAddress) public {
        delete permittedAddresses[theAddress];
    }

    
    function () public payable {
        
    }
    
}
