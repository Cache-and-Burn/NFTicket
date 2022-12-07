pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract TicketNFT is ERC721 {
  // Define the contract owner
  address public owner;

  // Define the ticket price
  uint256 public ticketPrice;

  // Define total supply
  uint256 public totalSupply;

  // Define the array of ticket holders
  mapping(uint256 => address) public ticketHolders;

  // Define NFT uri
  string public uri;

  // Redeemed tickets
  mapping(uint256 => bool) public redeemed;

  // Define ticketId
  uint256 public ticketId;

  // TODO create events

  constructor(uint256 _ticketPrice, uint256 _totalSupply, string memory _name, string memory _symbol, string memory _uri) public {
    
    owner = msg.sender;
    ticketPrice = _ticketPrice;
    totalSupply = _totalSupply;
    name = _name;
    symbol = _symbol;
    uri = _uri;
  }
  
  //////PUBLIC FUNCTIONS////// 

  // A function for purchasing a ticket
  function purchaseTicket() public payable {
    // Checks
    require(msg.value >= ticketPrice, "Insufficient funds");
    require(ticketId <= totalSupply);

    // Create a new NFT token and assign it to the caller
    ticketId = totalSupply() + 1;
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

  //////ADMIN FUNCTIONS//////

  // A function to adjust ticket price
  function setTicketPrice(uint256 _price) public {
    require(msg.sender == owner);
    ticketPrice = _price;
  }
  
}