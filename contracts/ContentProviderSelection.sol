// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/**

    Very simple 1st implementation (as discussed elsewhere)

 */

import "RBAC/Permissions.sol";

 contract ContentProviderSelection {

    address private cp;

    uint256 private amount;
    
    //To be integrated (next iteration: silent reverse dutch auction + random choice among the 20% cheapest ask - something like that) to a more complex mechanism to determine efficiently one good content provider
    function askForRfCProduction() external onlyMember onlyCP {
        //TO DO
    }
    function commitFunds() external onlyMember onlyCP {
        //TO DO
    }
 }