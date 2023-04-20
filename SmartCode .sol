// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// https://github.com/OpenZeppelin 
// Import will allow the use of OpenZepplin function
/*import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
*/
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyToken is ERC721, ERC721Enumerable, Ownable {
    // Counters is a library
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    Counters.Counter private limitedEditionCounter;

    // use for exclusive items function 
    struct ExclusiveItem {
        uint256 price;
        bool isAvailable;
        address owner; // Add owner member to struct
    }

    mapping(uint256 => ExclusiveItem) private exclusiveItems;
    uint256 public itemSold;

    // minimum ether sent requirement
    uint256 public mintRate = 0.00 ether; 

    // maximum supply
    uint public maxSupply = 50; 
    // state varaible that updates in the database 
    uint public amountItem = 0;     // datatype: unsigned interger (always positive)
    uint public limitedEditionSupply = 10; // Initialize the limited edition supply variable
    
    // event function is for anyone on the blockchain can subscribe to this set event
    event Increment(uint value); 
    event Decrement(uint value); 

    // ----------------------------------------------------------------------------------------------------
    //      IMPORTANT NOTE: THESE ARE THE FUNCTION USED FROM OPENZEPPLIN, IT'S NECESSARY TO MINT NEW TOKEN
    // ----------------------------------------------------------------------------------------------------
    // Constructor takes in two parameter.   1. brief description of NFT and stating that it's a token
    //                                       2. NFT symbol (KOI)
    constructor() ERC721("KOI Token", "KOI") {}
    // Future task: Linking the HTML/JS with the NFT Token 
    // Set the token URI for the metadata
    function _baseURI() internal pure override returns (string memory) {
        return "https://api.koi.com/";
    }

    // using OpenZeppelin function 
    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }
    // using OpenZeppelin function 
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
     // ----------------------------------------------------------------------------------------------------
            // OUR OWN CODE FOR THIS PROJECT VISION, REFER TO OUR CASE DIAGRAM
    // ----------------------------------------------------------------------------------------------------

     function mintLimitedEditionToken(address to, uint256 tokenId) public onlyOwner {
        // Ensure the token ID is within the limited edition range
        require(tokenId >= maxSupply && tokenId < (maxSupply + limitedEditionSupply), "Token ID is not within the limited edition range");

        // Ensure the limited edition supply has not been reached
        require(limitedEditionCounter.current() < limitedEditionSupply, "Limited edition supply has been reached");

        // Mint the limited edition token to the specified address
        _safeMint(to, tokenId);

        // Increment the limited edition counter
        limitedEditionCounter.increment();
    }

    event ItemSold(uint256 tokenId, address buyer, uint256 price);

    function sellExclusiveItem(address buyer, uint256 tokenId) public payable {
        // Ensure the item exists and is available for sale
        require(exclusiveItems[tokenId].owner != address(0), "Item does not exist");
        require(exclusiveItems[tokenId].isAvailable == true, "Item is not available for sale");

        // Ensure the buyer has enough ether to purchase the item
        require(msg.value >= exclusiveItems[tokenId].price, "Insufficient ether to purchase item");

        // Transfer the ether to the seller
        address payable seller = payable(exclusiveItems[tokenId].owner);
        seller.transfer(msg.value);

        // Mark the item as sold
        exclusiveItems[tokenId].isAvailable = false;
        exclusiveItems[tokenId].owner = buyer;

        // Emit event
        emit ItemSold(tokenId, buyer, exclusiveItems[tokenId].price);
    }

    // ----------------------------------------------------------------------------------------------------
            // OUR OWN CODE FOR MODIFIERS AND FUNCTION
    // ----------------------------------------------------------------------------------------------------
    // Every minted NFT will cost ether, hence "payable" 
    function mintToken(address to) public payable {
        // Whatever wallet address its connected will be its token
        uint256 tokenId = _tokenIdCounter.current();
        // Maxsupply allows the owner to set the maximum supply of tokens that can be minted
        require(totalSupply() < maxSupply, "Can't mint anymore, reached max supply"); 
        // Mint rate is applied 
        require(msg.value >= mintRate, "Not enough ether sent, the rate for ether is 0.01"); 
        // Updating its ID with the newly minted token 
        _tokenIdCounter.increment();
        // mint an NFT to specific address
        _safeMint(to, tokenId);
    }

    // Main account aka owner can withdraw when someone mint new token or when ether are transfer
    function withdraw() public onlyOwner {
        // Must be greater than 0 ether for withdraw to occur
        require(address(this).balance > 0, "Balance is 0"); 
        // Withdraw ether will go into the main account
        payable(owner()).transfer(address(this).balance); 
    }
    // A function to check the balance of the contract
    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }   
    // This function allows the owner to check the balance of the contract
    function getTotalMinted() public view returns (uint256) {
        return totalSupply();
    }
    // This function allows anyone to get the owner of a specific token
    function getOwnerOfToken(uint256 tokenId) public view returns (address) {
        return ownerOf(tokenId);
    }
    // This function allows the owner of a token to transfer it to another address
    function transferToken(address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(_msgSender(), to, tokenId);
    }
    // This function allows the owner of a token to burn it, i.e., remove it from the contract and destroy it
    
    function burnToken(uint256 tokenId) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not owner nor approved");
        _burn(tokenId);
    }

}