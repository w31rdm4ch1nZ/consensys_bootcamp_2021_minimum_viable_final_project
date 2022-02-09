// // SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "./RBAC/Permissions.sol";
import "./FundsManager.sol";

contract MembershipNFT is ERC721Burnable, ERC721Enumerable, Permissions {
    
    //using Counters for Counters.Counter;
    uint256 public tokenCounter = 0;

    // NFT data
    mapping(uint256 => uint256) public amount;
    mapping(uint256 => uint256) public matureTime;

    constructor() ERC721("MembershipNFT", "MBR") {
    }

    function mintMemberToken(address _recipient, uint256 _amount, uint256 _matureTime) public onlyOwner returns (uint256) {
        _mint(_recipient, tokenCounter);

        // set values
        amount[tokenCounter] = _amount;
        matureTime[tokenCounter] = _matureTime;

        // increment counter
        tokenCounter++;

        return tokenCounter - 1; // return ID
    }

    function membershipTokenDetails(uint256 _tokenId) public view returns (uint256, uint256) {
        require(_exists(_tokenId), "MembershipNFT: Query for nonexistent token");

        return (amount[_tokenId], matureTime[_tokenId]);
    }

    function contractAddress() public view returns (address) {
    return address(this);
    }

    // to avoid compiler warnings associated to multiple inheritance and override not specified, we explicitly declare it:
    function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal override(ERC721, ERC721Enumerable) { }

    function supportsInterface(bytes4 _interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) { }
        
}