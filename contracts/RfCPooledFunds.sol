// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "./RequestForContent.sol";
import "./Permissions.sol";

contract RfCPooledFunds is Permissions {

    //TO DO:
    //Contracts that allows to keep track of the funds associated to an RfC token 
    // and also the share of those by an individual account in that pooled fund.
    //      => eventually: ERC20 contract (WETH over Eth) => goes hand in hand with ERC1155 shift

    function poolFundsForRfC() external onlyFMProxy /*see for creating a few roles if you have time for that */ {

    } 

    


}