// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./RequestForContent.sol";
// for defining role-based access control:
import "@openzeppelin/contracts/access/AccessControl.sol";

contract FundsManager {

    bytes32 public constant MEMBERS_W_SAFETY_DEPOSIT = keccak256("MEMBERS_W_SAFETY_DEPOSIT");

    address public user;
    //eventually make those 2 state variable the same... => can encompass EOA and contract addresses, no pb.
    address public addr;

    // allows to track the amount of one investor in one RfC (can have several investments):
    // investor address => RfCid => amount   
    mapping(address => mapping(uint256 => uint256)) public investorAmountToSpecificRfC;

    mapping(address => mapping(address => uint)) public allowance;
    
    uint256 private contractBalance = address(this).balance; // to be used in functions where the state can be changed (limiting the scope through private)
    
    //uint256 private amount;

    //keep track of the amount for a given RfC token:
    mapping(address => mapping(uint256 => uint256)) private rfcIdFund;

    // used in SimpleInvestorsVote:
    uint256 private securityDeposit = 0.1; // arbitrary value for now in eth (should be expressed in $stablecoin eventually - next iteration)

    // required for all users of the protocol
    mapping (address => mapping(uint256 => bool)) private safeDepositMade;

    //mapping(bool => uint256) private amountUserDepositCommitedToTheProtocol;

    //mapping (address => mapping (uint256 => bool)) private securityDepositIsCommittedToAnRfC;

    uint256 public immutable MIN_ESCROW_TIME = 30 days;

    mapping (address => mapping (uint256 => bool)) userSecurityDepositStatus;

    bool private locked;

    uint256 public shareOfRfCOwnership;

    uint256 private ratio;

    mapping (address => mapping(uint256 => uint256)) public shareRatioOfRfC; 

    //a value that says when a RfC is passes the proposal round and is now in "processing" (by a CP) status:
    // => this value should be returned to this contract by the contract implementing the proposal logic
    bool public hasPassed = false;

    modifier hasFunds{
        require(user.msg.value >= msg.value, "The user has not enough funds for the tx to happen");
        _;
    }

    modifier userHasSecurityDeposit{
        require(userSecurityDepositStatus == true, "The user does not have made the safety deposit that enables to act as investor  or content provider");
        _;
    }


    event madeSafeDeposit(address indexed member);

    event DepositETH(address userDepositing, uint deposit);

    event withdrawSafeDeposit(address investor, bool success);

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

    // get security deposit status for a given account
    function getSDstatus(address _user) public view returns(bool) {
        
        return userSecurityDepositStatus;
    }

    function getRfCFund(uint256 _id, address _user, address _RFCToken) public view returns(uint256) {
        require(_id >= 0, "not a valid id");
        require(_tokenAddr != 0, "address can't be 0, the contract has to exist already");
        require(_user != 0, "invalid EOA");
        address rfcTokenAddress;
        rfcTokenAddress = getRfCTokenAddress(_id);

        //TO DO: get the amount of funds allocated to a specific RfC (maybe you don't need the token address but its id is enough?)
    }

    function getRfCTokenAddress(uint256 _id) public view {
        // check if RfC exists => RfC should not ever have the same id => check if Counters from openZeppelin gives this certitude... 
        // TO DO
    }

    function getAmountUserDepositCommitedToTheProtocol(address _user) external view {

        return amountUserDepositCommitedToTheProtocol;
    }

    /**FINISH THAT **/
    // function depositETHandLock() external payable override userHasSecurityDeposit {
        
    //     require(msg.value >= securityDeposit, "the amount provided is insufficient to constitute a safetyDeposit");

    //     balance[msg.sender] -= msg.value;

    //     address(this).balance += msg.value;

    //     hasSafetyDeposit[msg.sender] = true;withdrawSafeDeposit(msg.sender, true);
    //         rfcFund += _investor[safeDeposit];
    //         //_investor.
    //     }
    //     else if () {
    //         //check if amount includes a safeDeposit amount
    //         require(_amount >= instanceFundsManagerContract.securityDeposit);
    //         balance[_investor] -= _amount;
    //         instanceFundsManagerContract.

    //         instanceFundsManagerContract.rfcFund += 300;
        

    //     signalInterest(_investor);
    //     }
    //     else (instanceFundsManagerContract.securityDeposit ){
    //         //...
    //     }
            
    //     emit DepositETH(_userDepositing, msg.value);
    // }

    function investETH() external payable onlyMember {

    } 


    function safeDeposit(address _member) public {
        _setupRole(MEMBERS_W_SAFETY_DEPOSIT, member);

         
        emit madeSafeDeposit(_member);
    } 

    function initiateWithdrawSafeDeposit() external onlyMember {

        //starts a timer that last about 30 days (check the ) that once done allow direct withdrawal (simplest form I can think of now)

        // if timer finished, then withdraw, then once withdraw succesfully, revoke membership (that might be a tricky one in terms of
        //  order and the access control you've implemented that way... anyway do it like that for now)

        //change status to non-member:
        _revokeRole(MEMBERS_W_SAFETY_DEPOSIT, member);

        //events: withdraw success or not, and then membership stopped 
        emit withdrawSafeDeposit(msg.sender, true);
    }

    function getPooledRfCamount(uint256 _RfCid) public view returns(uint256 rfcPoolAmount) {
        // TO DO
    }

    function allocateFundsToRfC(address _user,uint256 _id) public onlyMember returns(uint256 totalAmount) {

    }

    function setLocked(address _user, uint256 _amount) private {
        // lock eth (swapped in DAI) for 30 days

        //create correct variables for that
        require(userSecurityDepositStatus[_user][_amount] != true, "The security deposit is already met");

        //funds[_user] = sent to escrow

    }

    function unlock(address _user, uint256 _amount) private {
        //call it from another function in this contract either once condition for unlock funds are met, or because the expiration date is reached
    }

    function withdrawETH() external onlyMember {


    }


    /** Interactions with RequestForContent contract: **/

    function getRfCid(address _investorOrCP, uint256 _id) external view {
        require(id >= 0, "id is invalid number");

        return RfC.getRfCid(_id);
    }

    function setRfCIdFund(uint256 _id) public {
        //sum of all investors' deposits for a certain RfC
        
    }

    function commitFundsToRfC(uint256 _id, uint256 _amount) internal  {
        // way to lock/commit an amount to a specific NFT

        //sum of all funds allocated to an RfC token:
        return allocateFundsToRfC();
    }

    //Default functions in case of accidental crypto sent to the contract => revert

    fallback() external payable {
        revert();    
    }

}