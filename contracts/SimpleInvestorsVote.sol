// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "./FundsManager.sol";
import "./Permissions.sol";

contract SimpleInvestorVote {

//     //Investors lock funds (same amount as the proposer) or 
//     //  investors having already "security deposit" (locked funds) can signal their interest for the RfC by having ready 
//     //  the amount of their safe deposit (or adding same amount) to be locked/commited to the RfC production (that is funds locked for a minimum of 30 days
//     //  and in the event of success acceptance of the RfC and successfull  CP selection, funds are approved already to be used for the RfC production)
    
//     address public instanceFundsManagerContract /*= address*/; 
//     address public instanceRfCContract;

//     mapping (address => bool) statusRfCinProposal = false;


//     // modifier onlyInProposal{
//     //     require(statusRfCinProposal == true, "This is not a request for content that is issued for the voting round.");
//     //     _;
//     // }

//     modifier onlyInvestor() {
//         require(instanceFundsManagerContract.amountUserDepositCommitedToTheProtocol > 0.1, "The user did not invest in the protocol yet");
//         _;
//     }

//     // function approveSecurityDepositForRfC(address _investor, uint256 _deposit, uint256 _RfCid) private onlyInvestor {

//     //     //check again this logic (basically logic of a safe deposit => locked funds + a defined amount locked + time locked)
//     //     require(_investor.balance >= _deposit, "not enough funds");
//     //     require(instanceFundsManagerContract.madeSafeDeposit == locked, "no safe deposit");
//     //     require(_deposit == instanceFundsManagerContract.securityDeposit, "the investor can't vote as she does not have the amount requried as security deposit available and approved for this RfC");

//     //     commitFundsToRfC(_investor, _deposit);
//     // }

//     // function commitFundsToRfC(address _investor, uint256 _amount) internal {
        
//     //     if (instanceFundsManagerContract.securityDeposit) {
//     //         if (instanceFundsManagerContract.securityDepositIsCommitedToAnRfC == false) {    
//     //             instanceFundsManagerContract.rfcFund += _investor[safeDeposit];
//     //             //_investor.
//     //         }
//     //         else {
//     //             //check if amount includes a safeDeposit amount
//     //             require(_amount >= instanceFundsManagerContract.securityDeposit);
//     //             balance[_investor] -= _amount;
//     //             instanceFundsManagerContract.

//     //             instanceFundsManagerContract.rfcFund += 300;
//     //         }

//     //         signalInterest(_investor);
//     //     }
//     //     else if (instanceFundsManagerContract.securityDeposit ){
//     //         //...
//     //     }
//     // }

//     function signalInterest(address _investor, uint256 _deposit) internal payable {
//         require(_investor.balance >= _deposit, "not enough funds");
        
//         _investor.balance -= _deposit;
//         address(instanceFundsManagerContract).balance += _deposit;

//         instanceFundsManagerContract.rfcFund += 300;

//     }

}