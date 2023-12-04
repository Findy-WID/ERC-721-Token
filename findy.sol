
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract FindyToken is ERC721, Ownable, Pausable {
    // Mapping from token ID to token URI
    mapping(uint256 => string) private _tokenURIs;

    // Base URI for metadata
    string private _baseTokenURI;

    // Constructor
    constructor(string memory baseTokenURI) ERC721("Findy", "FD") {
        _baseTokenURI = baseTokenURI;
    }

    // Mint new tokens
    function mint(address to, uint256 tokenId) external onlyOwner {
        _safeMint(to, tokenId);
    }

    // Optional: Set the base URI for all token IDs
    function setBaseURI(string memory baseTokenURI) external onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

    // Compulsory: Get the base URI for all token IDs
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // Compulsory: Get the token URI for a specific token ID
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    // Compulsory: Approve another address to spend on behalf of the owner
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");
        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not owner nor approved for all");
        _approve(to, tokenId);
    }

    // Compulsory: Transfer ownership of a token
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal whenNotPaused virtual override {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // Optional: Set the token URI for a specific token ID
    function setTokenURI(uint256 tokenId, string memory tokenURI) external onlyOwner {
        _tokenURIs[tokenId] = tokenURI;
    }

    // Optional: Pause the contract
    function pauseToken() external onlyOwner {
        _pause();
    }
}
