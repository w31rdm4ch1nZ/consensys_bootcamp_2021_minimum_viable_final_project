// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./RequestForContent.sol";

contract FundsManager {

    address public user;
    
    uint256 public contractBalance; // by default can be accessed by this.balance, or something like that
    
    uint256 private amount;

    uint256 private rfcFund;

    // used in SimpleInvestorsVote:
    uint256 public immutable securityDeposit = 300; // 300$ in stablecoin

    mapping (address => mapping(uint256 => bool)) madeSafeDeposit;

    mapping (address => mapping (uint256 => bool)) private securityDepositIsCommitedToAnRfC;

    uint256 public immutable MIN_ESCROW_TIME = 30 days;

    mapping (address => mapping (uint256 => bool)) userHasSecurityDeposit;

    bool private locked;

    uint256 public shareOfRfCOwnership;

    uint256 private ratio;

    mapping (address => mapping(uint256 => uint256)) public shareRatioOfRfC; 

    //a value that says when a RfC is passes the proposal round and is now in "processing" (by a CP) status:
    // => this value should be returned to this contract by the contract implementing the proposal logic
    bool public hasPassed = false;

    //mapping (address => mapping (address => bool)) isIn

    enum ParticipantType {
        isInvestor,
        isContentProvider,
        isUser
    }

    // value should be assigned in a function called specifcally and only in a context where the caller is an investor (send ether for a RfCid specified as input)
    ParticipantType userType = ParticipantType.isUser;

    modifier onlyInvestors{
        require(userType == ParticipantType.isInvestor, "The user has to be an investor");
        _;
    }

    modifier onlyCP{
        require(userType == ParticipantType.isContentProvider, "The user has to be an investor");
        _;
    }

    modifier onlyFundsManager{
        require(user == address(this), "This sate modification can only be triggered by the FundsManager contract.");
        _;
    }

    constructor()  {
        //test pre-game (to disappear)
        
        //Define roles of the pattern access control
        // TO DO

        //instantiates the other contracts and have the address "known" by this contract
        RequestForContent RfC = new RequestForContent();

    }

    /*
    receive() external payable {
        userType = ParticipantType.isInvestor;

        //increment contract balance
        contractBalance += msg.value;
    }
    */

    //Returns balance of InvestorEscrow contract
    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    function depositETH(uint256 bundleId) external payable override {

        uint256 amount = msg.value;

        bundleETHHoldings[bundleId] = bundleETHHoldings[bundleId].add(amount);
        emit DepositETH(_msgSender(), bundleId, amount);
    }
    function manageInvestorsFunds() internal onlyInvestors {
        //TO DO
        //the usual require()
        //add to FundsManager (could have a contract called Fund instantiated for more readability - more to think about)


    }

    //function sendInvestors() internal onlyProtocol {}

    //test only
    function setContractBalance(uint256 _x) public {
        contractBalance = _x;
    }

    function setLocked(address _user, uint256 _amount) private onlyFundsManager {
        // lock eth (swapped in DAI) for 15 days

        //create correct variables for that
        require(userHasSecurityDeposit[_user][_amount] != true, "The security deposit is already met");


    }

    function unlock(address _user, uint256 _amount) private {
        //call it from another function in this contract either once condition for unlock funds are met, or because the expiration date is reached
    }


    /** Interactions with RequestForContent contract: **/

    function getRfCid(address _investorOrCP, uint256 _id) external {
        require(id >= 0, "id is invalid number");

        return RfC.getRfCid(_id);
    }



    //Default functions in case of accidental crypto sent to the contract => revert

        fallback() external payable {
        
    }




}