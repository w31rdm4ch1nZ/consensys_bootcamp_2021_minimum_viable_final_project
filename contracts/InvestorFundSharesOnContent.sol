// // SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
// import "./FundsManager.sol";
// import "./RBAC/Permissions.sol";

// /** Eventually leading to an open Content Shares Market is something that is tought of */


/* MIGHT BE USELESS AS I USE NFT CONTRACT TO CALCULATE AND THEN SEND TO THE FundsManager contract so it handles
the investors fee payment 
        => calculation are done through the RfC NFT data, and then payments managed by the FM contract (through the inheritance of te PullPayment contract) 
*/

contract InvestorFundSharesOnContent /**is ERC20, ERC20Burnable, Ownable, ERC20Permit, ERC20Votes, Permissions **/{

//   //use safeERC20

//   mapping(address => uint256) public amountERC20;

//   constructor()
//     ERC20("InvestorContentShares", "ICS")
//     ERC20Permit("InvestorContentShares") {
//       //no preminted => mint for each new RfC token issued according to the amount and the ratio of each investor put in the total 
//       // [FOR FUNDSMANAGER contract: (shares are calculated with a quadratic function so passed the CP's funding threshold no whale entity 
//       // can DOMINATE/take over one content revenue)
//   }
//   function mint(address to, uint256 amount) public onlyFMProxy {
//       _mint(to, amount);
//   }

}
