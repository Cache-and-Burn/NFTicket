pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract TicketNFT is ERC721 {
  // Define the contract owner
  address public owner;

  // Define the ticket price
  uint256 public ticketPrice;

  // Define the array of ticket holders
  mapping(uint256 => address) public ticketHolders;

  // Redeemed tickets
  mapping(uint256 => bool) public redeemed;

  // The contract constructor
  constructor() public {
    // Set the contract owner to the address that deployed the contract
    owner = msg.sender;
  }

  // A function for purchasing a ticket
  function purchaseTicket() public payable {
    // Check if the caller has enough funds
    require(msg.value >= ticketPrice, "Insufficient funds");

    // Create a new NFT token and assign it to the caller
    uint256 ticketId = _totalSupply() + 1;
    _mint(msg.sender, ticketId);

    // Add the caller to the array of ticket holders
    ticketHolders[ticketId] = msg.sender;

    // Transfer the ticket price to the contract owner
    payable(owner).transfer(ticketPrice);
  }

  // A function for transferring a ticket
  function transferTicket(uint256 ticketId, address recipient) public {
    // Check if the caller is the current owner of the ticket
    require(_ownerOf(ticketId) == msg.sender, "You are not the current ticket holder");

    // Check if the recipient is not already a ticket holder
    require(!ticketHolders[ticketId], "The recipient is already a ticket holder");

    // Transfer the NFT token to the recipient
    _safeTransferFrom(msg.sender, recipient, ticketId);

    // Update the array of ticket holders
    ticketHolders[ticketId] = recipient;
  }

  // A function for checking the validity of a ticket
  function checkValidity(uint256 ticketId) public view returns (bool) {
    // Return whether the caller is the current owner of the NFT token
    return _ownerOf(ticketId) == msg.sender;
  }

  // A function for redeeming a ticket
  function redeemTicket(uint256 ticketId) public {
    // Check if the caller is the current owner of the ticket
    require(_ownerOf(ticketId) == msg.sender, "You are not the current ticket holder");

    // Add to list of redeemed tickets
    redeemed[ticketId] = true;
  }
  
}