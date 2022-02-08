// // SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "./RBAC/Permissions.sol";

contract RequestForContentNFT is ERC721Burnable, ERC721Enumerable, Permissions {
    
    //using Counters for Counters.Counter;
    uint256 public tokenCounter = 0;

    // NFT data
    mapping(uint256 => uint256) public amount;  // totalfunds managed by contract
    mapping(uint256 => uint256) public matureTime;  // acts like the lock() function you wanted to implement on the core contracts => do it like that.

    //investor's ratio on future content + fee calculation state variables
    // + make sure those are enabled only once redeemable features are inactive/inaccessible by the in vestor/member (a redeem once security)


    constructor() ERC721("RequestForContentNFTCommissioned", "RFCCO") {
    }
       
    function mintRfCInvestment(address _recipient, uint256 _amount, uint256 _matureTime) internal onlyFMProxy returns (uint256) {
        // minted by FM contract, with _amount = the total funds amount => called from FM contract 
        _mint(_recipient, tokenCounter);
    }
    
    function tokenDetails(uint256 _tokenId) public view returns (uint256, uint256) {
        require(_exists(_tokenId), "RfCNFT: Query for nonexistent token");

        return (amount[_tokenId], matureTime[_tokenId]);
    }

    //get token address (get rid of it in your core contract)
    function contractAddress() public view returns (address) {
    return address(this);
    }

    // to avoid compiler warnings associated to multiple inheritance and override not specified, we explicitly declare it:
    function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal override(ERC721, ERC721Enumerable) { }

    function supportsInterface(bytes4 _interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) { }
 
}