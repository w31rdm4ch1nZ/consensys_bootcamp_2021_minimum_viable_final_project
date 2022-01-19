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

    mapping(address => mapping(address => uint)) public allowance;
    
    uint256 private contractBalance = address(this).balance; // to be used in functions where the state can be changed (limiting the scope through private)
    
    uint256 private amount;

    uint256 private rfcFund;

    // used in SimpleInvestorsVote:
    uint256 public immutable securityDeposit = 0.1; // arbitrary value for now in eth (should be expressed in $stablecoin eventually - next iteration)

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

    modifier hasFunds{
        require(user.msg.value >= msg.value, "The user has not enough funds for the tx to happen");
        _;
    }

    modifier userHasSecurityDeposit{
        require(userHasSecurityDeposit == true, "The user does not have made the safety deposit that enables to act as investor  or content provider");
        _;
    }

    // not sure I need it now as I will be using the Owner access pattern
    modifier onlyInvestors{
        require(userType == ParticipantType.isInvestor, "The user has to be an investor");
        _;
    }

    modifier onlyCPs{
        require(userType == ParticipantType.isContentProvider, "The user has to be an investor");
        _;
    }

    modifier onlyFundsManager{
        require(user == address(this), "This sate modification can only be triggered by the FundsManager contract.");
        _;
    }

    event DepositETH(address userDepositing, uint deposit);
    constructor()  {
        //test pre-game (to disappear)
        
        //Define roles of the pattern access control
        // TO DO

        //instantiates the other contracts and have the address "known" by this contract
        RequestForContent RfC = new RequestForContent();

    }

    //Returns balance of InvestorEscrow contract
    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    function depositETHandLock() external payable override userHasSecurityDeposit {
        
        require(msg.value >= securityDeposit, "the amount provided is insufficient to constitute a safetyDeposit");

        balance[msg.sender] -= msg.value;

        address(this).balance += msg.value;

        hasSafetyDeposit[msg.sender] = true;

        if (securityDepositIsCommitedToAnRfC == false) {    
                
            rfcFund += _investor[safeDeposit];
            //_investor.
        }
        else if () {
            //check if amount includes a safeDeposit amount
            require(_amount >= instanceFundsManagerContract.securityDeposit);
            balance[_investor] -= _amount;
            instanceFundsManagerContract.

            instanceFundsManagerContract.rfcFund += 300;
        

        signalInterest(_investor);
        }
        else (instanceFundsManagerContract.securityDeposit ){
            //...
        }
            
        emit DepositETH(_userDepositing, msg.value);
    }

    function poolFundsForRfC(uint256 _RfCid) internal 

    function setLocked(address _user, uint256 _amount) private onlyFundsManager {
        // lock eth (swapped in DAI) for 30 days

        //create correct variables for that
        require(userHasSecurityDeposit[_user][_amount] != true, "The security deposit is already met");

        //funds[_user] = sent to escrow

    }

    function unlock(address _user, uint256 _amount) private {
        //call it from another function in this contract either once condition for unlock funds are met, or because the expiration date is reached
    }


    /** Interactions with RequestForContent contract: **/

    function getRfCid(address _investorOrCP, uint256 _id) external view {
        require(id >= 0, "id is invalid number");

        return RfC.getRfCid(_id);
    }

    function commitFundsToRfC(uint256 _id) internal onlyInvestors onlyCPs {
        // way to lock/commit an amount to a specific NFT

    }

    //Default functions in case of accidental crypto sent to the contract => revert

    fallback() external payable {
        revert();    
    }

}