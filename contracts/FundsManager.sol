// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
//import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";  // => quick double check to se how to use it (modifier or other stuff?)
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/TokenTimelock.sol";
import "./RequestForContent.sol";
import "./RfCEscrow.sol";
// for defining role-based access control:
import "./Permissions.sol";
contract FundsManager is Permissions, Initializable {

    using SafeERC20 for IERC20; // shouldn't be needed in 1st iteration as I limit ERC20-like to ether... or you make the choice to use WETH to simplify how you deal with tokens
                                // and stay in the ERC20 standards and the reuse is enables instead of coding you own custom logic for every crypto-asset (especially since
                                //  you intend to only use stablecoins in the end)

    //Protocols Contracts deployed through minting this contract:
    RequestForContent public rfcFactoryContract = new RequestForContent();
    RfCEscrow public escrowRfCContract = new RfCEscrow();

    address public user;
    //eventually make those 2 state variable the same... => can encompass EOA and contract addresses, no pb.
    address public addr;

    mapping(address => bool) internal membershipStatus = false;

    //mapping(address => uint256) private balanceAccount;   => nod needed => balance.addr

    mapping(address => uint256) private depositStartTime;    // to use only for cases different from safe deposits => use a specific state variable for both
    mapping(address => uint256) private memberSafeDepositStartTime;
    uint256 private maturationTime;   // used for calculation of the allowed withdraw time

    // allows to track the amount of one investor in one RfC (can have several investments):
    // investor address => RfCid => amount   
    mapping(address => mapping(uint256 => uint256)) public investorAmountToSpecificRfC;

    //mapping(address => mapping(address => uint)) public allowance;
    
    //uint256 private contractBalance = address(this).balance; // to be used in functions where the state can be changed (limiting the scope through private)
    
    //uint256 private amount;

    //keep track of the amount for a given RfC token:
    mapping(address => mapping(uint256 => uint256)) private rfcIdFund;

    // used in SimpleInvestorsVote:
    uint256 private immutable SECURITY_DEPOSIT = 0.1; // arbitrary value for now in eth (should be expressed in $stablecoin eventually - next iteration)

    uint256 public immutable MIN_ESCROW_TIME = 30 days;

    // required for all users of the protocol
    mapping (address =>  bool) private safeDepositMade;

    mapping(bool => uint256) private amountUserDepositCommitedToTheProtocol;

    //mapping (address => mapping (uint256 => bool)) private securityDepositIsCommittedToAnRfC;

    bool private locked;


    // you don't need all those var:
    uint256 public shareOfRfCOwnership;
    mapping (address => mapping(uint256 => uint256)) public shareRatioOfRfC; 
    uint256 private ratio;

    

    //a value that says when a RfC is passes the proposal round and is now in "processing" (by a CP) status:
    // => this value should be returned to this contract by the contract implementing the proposal logic
    bool public hasPassed = false;

   
    modifier hasFunds{
        require(user.msg.value >= msg.value, "The user has not enough funds for the tx to happen");
        _;
    }

    // Shoud not be useful since I use now onlyMember and membershipStatus
    // modifier userHasSecurityDeposit{
    //     require(userSecurityDepositStatus == true, "The user does not have made the safety deposit that enables to act as investor or content provider");
    //     _;
    // }

    modifier onlyMember() {
        require(membershipStatus == true, "Permissions: Caller does not have a safe deposit and active membership");
        _;
    }

    modifier withdrawApproved() {
        require(unlock, "funds are locked");
        require(block.timestamp >= depositStartTime + MIN_ESCROW_TIME);
        require(addr.balance <= msg.sender.balance);
        _;
    }

    // modifier onlyFMProxy() {
    //     require(isFMProxy(addres(this)), "Permissions: This call can only be initiated by the actual protocol's instance of FundsManager contract");
    //     _;
    // }

    // modifier onlyRFCFactoryContract() {
    //     require(address(rfcFactoryContract), "this can only be done from the RfC factory contract");
    //     _;
    // }

    event madeSafeDeposit(address indexed member);

    event DepositForRfC(address indexed userDepositing, uint256 deposit, uint256 indexed RfCid);

    event withdrawSafeDeposit(address investor, bool success);

    event cpRewardRedeemed(address _cp, uint256 _rfcId, uint256 _amount);

    event investorInvestmentRedeemed();

    event investorSharesMinted();

    function init() external override  initializer {
        //test pre-game (to disappear)
        
        //Define roles of the pattern access control
        _setupRole(FUNDS_MANAGER_ROLE, address(this));

        RequestForContent rfcContract = new RequestForContent();

    }

    //Returns balance of InvestorEscrow contract
    function getContractBalance() public view returns(uint256){
        return address(this).balance;
    }

    // check for security deposit status for a given account
    function getSDstatus(address _user) public view returns(bool) {
        
        return safeDepositMade;
    }

    function getRfCStatus(uint256 _rfcId) public view returns(bool) {
        //TO DO
    }

    function getRfCFund(uint256 _id, address _user, address memory _RFCToken) public view returns(uint256) {
        require(_id >= 0, "not a valid id");
        require(_RFCToken != address(0), "address can't be 0, the contract has to exist already");
        require(_user != 0, "invalid EOA");
        address rfcTokenAddress;
        rfcTokenAddress = getRfCTokenAddress(_id);

        //TO DO: get the amount of funds allocated to a specific RfC (maybe you don't need the token address but its id is enough?)
    }

    function getRfCTokenAddress(uint256 _id) public view {
        // check if RfC exists => RfC should not ever have the same id => check if Counters from openZeppelin gives this certitude... 
        // TO DO
    }

    function getAmountUserDepositForRfC(address _account, uint256 _amount, uint256 _RfCid) public returns (uint256 amount) {
        return investorAmountToSpecificRfC[_RfCid][_amount];
    }

    //nee to increment this number at every invest & CP deposit
    function getTotalAmountUserDepositToTheProtocol(address _user) public view returns (uint256) {

        return amountUserDepositCommitedToTheProtocol;
    }

    function setTotalAmountUserDepositToTheProtocol(address _user) internal {

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

    function investETH(uint256 RfCid, address _rfcToken) external payable onlyMember {
        require(msg.sender.balance >= msg.value, "user doesn't have emough funds => revert");


        address(this).balance += msg.value;
        depositStartTime = block.timestamp;
        //allocateFundsToRfC();
        //lockFunds(msg.sender);
        emit DepositForRfC(msg.sender, msg.value);

    } 


    function safeDepositForMembership(address _aspiringMember) public payable {
        // to think about: _setupRole(MEMBERS_W_SAFETY_DEPOSIT, member);
        require(msg.sender.balance >= 0, "balance must be positive");  // don't think it is useful...
        require(msg.value == 0.1 ether, "The amount of 0.1 ether is not reached");  // be ready for your exection to err here
                                                                                    // simply bc more ether has been sent, and so it reverts
                                                                                    // => how to make sure to maximize successful txs for users?
                                                                                    //  so they get their funds back in case too much is sent?
        uint256 startTime;

        lockSafeDeposit(_aspiringMember);
        //try {
        msg.sender.balance -= 0.1 ether;
        //test if you need this (as it will only be ether for now, you should not)
        //address(this).balance += msg.value;
        //}
        //catch {revert()}
        //safeDepositMade = true;

        //set member status
        //membershipStatus = true;
        //set safety deposit time to calculate the unlock time
        memberSafeDepositStartTime[startTime] = block.timestamp;                      // equivalent to now (using it to be explicit)
        emit madeSafeDeposit(_aspiringMember);
    } 

    function initiateWithdrawSafeDeposit(address _member) external onlyMember {

        //starts a timer that last about 30 days (check the ) that once done allow direct withdrawal (simplest form I can think of now)

        // if timer finished, then withdraw, then once withdraw succesfully, revoke membership (that might be a tricky one in terms of
        //  order and the access control you've implemented that way... anyway do it like that for now)

        //change status to non-member:
        _member[membershipStatus] = false;

        //events: withdraw success or not, and then membership stopped 
        emit withdrawSafeDeposit(msg.sender, true);
    }

    function getPooledRfCamount(uint256 _RfCid) public view returns(uint256 rfcPoolAmount) {
        // TO DO
    }

    function allocateFundsToRfC(address _user,uint256 _id, uint256 _unlockDate) public onlyMember returns(uint256 totalAmount) {
        //TO DO
        
    }

    // again by seting the scope to private I only allow a function from this contract (does not mean it can't be abused if not careful...)
    function lockSafeDeposit(address _user)private  payable onlyFMProxy {
        require(safeDepositMade[_user] != true, "The security deposit is already met");

        // >>>> check the conversion MIN_ESCROW_TIME to unix time so no bug:
        if (block.timestamp - MIN_ESCROW_TIME >= _user[memberSafeDepositStartTime]) {
            locked = true;
            safeDepositMade[_user] = true;
            address(this).balance += 0.1 ether;
        }
        else {
            locked = false;
            revert();   // I guess that would be enough? Trying to get an err that bubbles up to the iuser though
        }

    }

    function unlock(address _user, uint256 _amount) private {
        //call it from another function in this contract either once condition for unlock funds are met, or because the expiration date is reached
    }

    function withdrawETH() external onlyMember withdrawApproved {


    }

    //specific withdraw: when the RfC doesn't pass the investors vote (time of deposit for investors who vote with ether +
    //  15 days):
    function withdrawFromEscrow(address _account, uint256 _amount, uint256 _matureTime, uint256 _rfcId) external onlyMember withdrawApproved {
        require(_matureTime >= block.timestamp, "Escrow period not expired.");  // calculate the 30 days: time of deposit
                                                                                 // (should be recorded in a state variable, like block.timestamp f the tx)
                                                                                 // + 30 days (in linux time format)
                                                                                 // check withdrawApproved to implement part of requirements

        //that's a case requiring a burn feature:
        RequestForContent.burn(_rfcId);

        //(bool success, bytes data) = msg.sender.call{value: amount}("");

        //require(success, "Transfer failed.");

        emit Redeemed(msg.sender, amount);
    }

    function depositPayAccessContent(uint256 _RfCId, uint256 _amount) external {
        //as investors have shares to a content they produce (that they can eventually sell to other users,
        //  but that will change their status back ti users, or RfCIdInvestor = false), they 
        //  will call another function to access content, if needed, that encodes the logic of their shares
        //  in the content, etc. 
        require(msg.sender != Investor, "investors in this RfC should access this content through their dashboard");

        //should return a token that gives them all data/authorization to access content
    } 


    /** Interactions with RequestForContent contract: **/

    function getRfCid(address _investorOrCP, uint256 _id) external view {
        require(id >= 0, "id is invalid number");

        return rfcFactoryContract.getRfCid(_id);
    }

    function setRfCIdFund(uint256 _id) public {
        //sum of all investors' deposits for a certain RfC
        
    }

    function commitFundsToRfC(uint256 _id, uint256 _amount) internal  {
        // way to lock/commit an amount to a specific NFT

        //sum of all funds allocated to an RfC token:
        return allocateFundsToRfC();
    }

    //Default functions in case of accidental crypto sent to the contract => revert => INCLUDE THE revert() logic in
    //  the deposit function (eg. if an argument is missing, revert:   require(RfCid, etc. ))

    // fallback() external payable {
    //     //address(this).send(msg.value);
    //     revert();
    // }

    function getFMContractAddr() external view onlyFMProxy returns(address) {
        return address(this);
    }


}