// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/**

    Very simple 1st implementation (as discussed elsewhere)
        => create the role CP and modif onlyCP in Permissions...
 */

import "./RBAC/Permissions.sol";

 contract ContentProviderSelection is Permissions {
    RequestForContentNFT public rfcNFT;   

    address private cp;

    mapping(address => mapping(uint256 => mapping (uint256 => bool))) public cpCommitedFunds = false;

    bool public initialized = false;

    event Escrowed(address _from, address _to, uint256 _amount, uint256 _matureTime);
    event Redeemed(address _recipient, uint256 _amount);
    event Initialized(address _rfcNFT);

    modifier isInitialized() {
        require(initialized, "Contract is not yet initialized");
        _;
    }

    function initialize(address _rfcNftAddress) external /*onlyOwner*/ {
        require(!initialized, "Contract already initialized.");
        rfcNFT = RequestForContentNFT(_rfcNftAddress);
        initialized = true;

        emit Initialized(_escrowNftAddress);
    }
    
    //To be integrated (next iteration: silent reverse dutch auction + random choice among the 20% cheapest ask - something like that) to a more complex mechanism to determine efficiently one good content provider
    function askFundsForRfCProduction(address _recipient, uint256 _rfcId, uint256 _duration) external payable onlyMember onlyCP isInitialized {
        require(_recipient != address(0), "Cannot escrow to zero address.");
        require(msg.value > 0, "Cannot escrow 0 ETH.");
        //TO DO
        //Simple working version (where I assume an honest CP who sets the amount right, because rn I accept the inputs from the frontend... (entirely under client control))
        uint256 amount = msg.value;
        cpCommitedFunds[msg.sender][_rfcId][amount] = true;


    }

    function commitFundsToRfC(address _recipient, uint256 _amount) external onlyMember onlyCP {
        //TO DO
        // amount would have been committed already (so the CP cannot commit an arbitrary amount after the RfC agreement)
        
    }

    function simpleRedeemFunds(address _recipient, uint256 _amount) {
        require(_recipient == msg.sender, "only the account commited can redeem funds");
        require(cpCommitedFunds[msg.sender][_rfcId][_amount] = true, "this account can't redeem");
        //require(_amount <= )
        //cpCommitedFunds[msg.sender][_rfcId][_amount] = true;

    }

 }