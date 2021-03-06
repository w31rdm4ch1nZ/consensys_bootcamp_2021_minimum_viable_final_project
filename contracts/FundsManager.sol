// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/** 
    >>>> I ran out in an OOG error on this contract. What made it possible for me to get out of this is commenting each reference to the external RfC contract
    >>>> I need to research that to understand how to make it work at some point in my test/building process.
**/

//import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";  
//import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
//import "@openzeppelin/contracts/token/ERC20/utils/TokenTimelock.sol";
import "./RequestForContent.sol";
import "./RfCEscrow.sol";
// for defining role-based access control:
import "./RBAC/Permissions.sol";
import "./membership/MembershipNFT.sol";
contract FundsManager is Permissions, Initializable, ReentrancyGuard {
    
    MembershipNFT public membershipNFT;
    RequestForContentNFT public rfcNFT;
    bool public initialized = false;

    //using Counters for Counters.Counter;
    //using SafeERC20 for IERC20; // shouldn't be needed in 1st iteration as I limit ERC20-like to ether... or you make the choice to use WETH to simplify how you deal with tokens
                                // and stay in the ERC20 standards and the reuse is enables instead of coding you own custom logic for every crypto-asset (especially since
                                //  you intend to only use stablecoins in the end)
    //Counters.Counter private id;
    //Protocols Contracts deployed through minting this contract:
    
    
    //RequestForContent public rfcInstanceContract = new RequestForContent(); 
    //RfCEscrow private escrowRfCContract = new RfCEscrow();

    address private user;
    //eventually make those 2 state variable the same... => can encompass EOA and contract addresses, no pb.
    address private addr;
    address private owner;

    mapping(address => uint256 ) private balance;

    //mapping(address => bool) private membershipStatus;    => no more needed if you make it an NFT

    //mapping(address => uint256) private balanceAccount;   => nod needed => balance.addr

    mapping(address => uint256) private depositStartTime;    // to use only for cases different from safe deposits => use a specific state variable for both
    mapping(address => uint256) private memberSafeDepositStartTime;
    mapping(address => uint256) private maturationTime;

    // allows to track the amount of one investor in one RfC (can have several investments):
    // investor address => RfCid => amount   
    mapping(address => mapping(uint256 => uint256)) private investorAmountToSpecificRfC;

    //mapping(address => mapping(address => uint)) public allowance;
    
    //uint256 private contractBalance = address(this).balance; // to be used in functions where the state can be changed (limiting the scope through private)
    
    //uint256 private amount;

    //keep track of the amount for a given RfC token:
    mapping(address => mapping(uint256 => uint256)) private rfcIdFund;

    mapping(uint256 => address) private tokenRfCAddr;

    // used in SimpleInvestorsVote:
    uint256 private immutable SECURITY_DEPOSIT = 0.1 ether; // arbitrary value for now in eth (should be expressed in $stablecoin eventually - next iteration)

    uint256 private immutable MIN_ESCROW_TIME = 30 days;

    // required for all users of the protocol
    mapping (address =>  bool) private safeDepositMade;

    //mapping(bool => uint256) private amountUserDepositCommittedToTheProtocol;

    mapping(address => uint256) private totalAmountUserDepositToTheProtocol;

    //mapping (address => mapping (uint256 => bool)) private securityDepositIsCommittedToAnRfC;

    bool private locked;


    // you don't need all those var:
    uint256 private shareOfRfCOwnership;
    mapping (address => mapping(uint256 => uint256)) private shareRatioOfRfC; 
    uint256 private ratio;

    mapping(address => mapping(uint256 => uint256)) private rfcNFTTokenIdFundAmount;

    //a value that says when a RfC is passes the proposal round and is now in "processing" (by a CP) status:
    // => this value should be returned to this contract by the contract implementing the proposal logic
    bool private hasPassed = false;

    modifier onlyMember() {
        require(membershipStatus[user] == true, "Permissions: Caller does not have a safe deposit and active membership");
        _;
    }


    modifier withdrawApproved() {
        require(locked == false, "funds are locked");
        require(block.timestamp >= depositStartTime[user] + MIN_ESCROW_TIME);
        require(addr.balance <= msg.sender.balance);
        _;
    }

    modifier isInitialized() {
        require(initialized, "Contract is not yet initialized");
        _;
    }

    modifier rfcInPrdouction() {
        require(hasPassed == true, "This rfc has not been approved and/or found a CP ready to deliver");
        _;
    }

    // you have to order it...
    //Membership related events: 
    event MembershipMinted(address _from, address _to, uint256 _amount, uint256 _matureTime);
    event RedeemMembership(address _member/*, uint256 _amount*/); // => for membership it's always the same amount

    //RfC investor's related events
    event RfCMinted(address _from, address _toRfCEscrow, uint256 _amount, uint256 _matureTime); // the tricky argument is _toRfCEscrow: relates to an NFT acting as an Escrow contract also (still to be explored)
                                                                                                //  => actually handled by the RfCNFT contract...
    event DepositForRfC(address indexed _userDepositing, uint256 _deposit, uint256 indexed _RfCid);
    event RfCCancelled(address _member, uint256 _amount);
    event InvestmentRedeemed(address indexed investor, uint256 indexed rfcId, uint256 amount);  //rfcId is here so it only redeems the amount for a specific Rfc (not all RfCs an investor might have invested in)
    event InvestorSharesMinted(address indexed investor, uint256 amount);   // part of the RfC NFT: tracking its investors positions *and future shares*
    event InvestorRfCNFTRedeemedFutureShares(address indexed investor, uint256 ratio, uint256 _amount); // where _amount is a mix of ERC20 wrapper and RfC NFT:
                                                                                                        //  => no, it's an NFT that *defines a fee* taken by the investor 
                                                                                                        // on the future access to the content by other members
    
    //initialize for both NFT contracts (membership and RfC) => for now try to separate both core logic: the
    // soon to be DeFi powered one, and protocol treasury so far, and the definition of the RfC itself in a trsutless manner 
    // (going further a content/information market that would allow new incentive setings vs. current ones through the Internet as we know it (Google ad tracking based revenue, etc.))
    event Initialized(address _membershipNFT, address _rfcNFT);
    
    //Content Providers events:
    event CPRewardRedeemed(address indexed cp, uint256 indexed rfcId, uint256 amount);
   

    event FundsCommittedToRfC(address user, uint256 rfcId, uint256 unlockDate);

    function initialize(address _membershipNFT, address _rfcNFT) external /*onlyOwner*/ {
        require(!initialized, "Contract already initialized.");
        membershipNFT = membershipNFT(_membershipNftAddress);
        rfcNFT = frcNFT(_rfcNFTAddress);

        initialized = true;

        emit Initialized(_membershipNFTAddress);
    }


    function getContractBalance() public view returns(uint256){
        return balance[address(this)];
    }

    function getContractAddress() public view returns (address) {
        return address(this);
    }   

    // check for security deposit/membership status for a given account
    function getSDstatus(address _user) public view returns(bool) {
        
        return safeDepositMade[_user];
    }

    function getRfCStatus(uint256 _rfcId) public view returns(bool) {
        if (hasPassed == true) {
            return true;
        }
        else {
            return false;
        }
    }

    function getRfCFundAmount(uint256 _amount, uint256 _rfcId) public view returns(uint256) {
        address rfcTokenAddress;
        rfcTokenAddress = getRfCTokenAddress(_rfcId);
        
        return rfcNFTTokenIdFundAmount[rfcTokenAddress][_rfcId];
    }

    // Not sure I need it since the rfc NFT minted will act as an escrow for the funding 
    function setRfCFundAmount( address _user, uint256 _rfcId, address  _rfcToken, uint256 _amount) internal nonReentrant {
        require(_rfcId >= 0, "not a valid id");
        require(_rfcToken != address(0), "address can't be 0, the contract has to exist already");
        require(_user != address(0), "invalid EOA");
        
        address rfcTokenAddress;
        rfcTokenAddress = getRfCTokenAddress(_rfcId);

        //TO DO: get the amount of funds allocated to a specific RfC 
        rfcNFTTokenIdFundAmount[rfcTokenAddress][_rfcId] += _amount;
    }

    function getRfCTokenAddress(uint256 _rcfId) public view returns (address) {
        // check if RfC exists => RfC should not ever have the same id => check if Counters from openZeppelin gives this certitude... 
        // TO DO
        
        return tokenRfCAddr[_rcfId];    // should be set when once mint() happens successfully => sort of callback added to the mintn function called on the 
                                            // RfC NFT contract mint() function.
    }

    // only useful if you can't track the NFT address following their minting (=>RfC.sol contract) 
    // function setRfCTokenAddr(uint256 _id, address _rfc) internal {
    //     //tokenRfCAddr[_id] = ?? => address of the minted token
    // }

    function getAmountUserDepositForRfC(address _account, uint256 _amount, uint256 _rcfId) public view returns (uint256 amount) {
        return investorAmountToSpecificRfC[_account][_rcfId];
    }

    //need to increment this number at every invest & CP deposit
    function setTotalAmountUserDepositToTheProtocol(address _user, uint256 _amount) external nonReentrant returns (uint256) {

        return totalAmountUserDepositToTheProtocol[_user] += _amount;  // => gives us the total amount invested by an account in the protocol
    }

    function setRfCTotalFundAmount(address _account, uint256 _rfcId, uint256 _amount) private {
        require(investorAmountToSpecificRfC[_account][_rfcId] >= 0, "this account did not dceposit any positive amount of Eth to this RfC");


    }

    function investETH(address _recipient, uint256 _rfcId, address _rfcToken, uint256 _extensionTimeFundsLocked) external payable onlyMember isInitialized nonReentrant {
        require(_recipient != address(0), "Cannot escrow to zero address.");
        require(msg.value > 0 ether, "user doesn't have emough funds => revert");

        uint256 amount = msg.value;

        depositStartTime[msg.sender] = block.timestamp;

        uint256 matureTime = depositStartTime[msg.sender] + 60 days + _extensionTimeFundsLocked;

        //balance[msg.sender] -= msg.value; => unnecessary fo ETH
             
        //track amount invested by a user on a specific RfC:
        investorAmountToSpecificRfC[msg.sender][_rfcId] += msg.value;

        rfcNFT.mintRfCInvestmentNFT(_recipient, amount, matureTime);

        emit DepositForRfC(msg.sender, _recipient, amount, _rfcId, matureTime);

    } 

    // as it is callable directly by anyone, you might not need the argument address, but only use msg.sender instead
    function safeDepositForMembership(address _recipient) external payable nonReentrant {
        // to think about: _setupRole(MEMBERS_W_SAFETY_DEPOSIT, member);
        //require(balance >= 0, "balance must be positive");  // don't think it is useful...
        require(_recipient != address(0), "can't be address 0, or the user loses funds");
        require(msg.value >= 0.1 ether, "The amount of 0.1 ether is not reached");  // be ready for your exection to err here
                                                                                    // simply bc more ether has been sent, and so it reverts
                                                                                    // => how to make sure to maximize successful txs for users?
                                                                                    //  so they get their funds back in case too much is sent?
        address aspiringMember = msg.sender;
        lockSafeDeposit(aspiringMember);

        uint256 amountToReturn = 0.1 ether - msg.value;

        //set member status
        //membershipStatus = true;
        //set safety deposit time to calculate the unlock time
        memberSafeDepositStartTime[aspiringMember] = block.timestamp;                      // equivalent to now (using it to be explicit)
        emit MadeSafeDeposit(aspiringMember);
    } 

    function redeemSafeDepositMembership(uint256 _tokenId) external onlyMember isInitialized nonReentrant {
        require(membershipNFT.ownerOf(_tokenId) == msg.sender, "Must own token to claim underlying 0.1 Eth");

        (uint256 amount, uint256 matureTime) = escrowNFT.tokenDetails(_tokenId);
        require(matureTime <= block.timestamp, "Escrow period not expired.");

        membershipNFT.burn(_tokenId);

        (bool success, ) = msg.sender.call{value: amount}("");

        require(success, "Transfer failed.");

        emit Redeemed(msg.sender, amount);
        //starts a timer that last about 30 days (check the ) that once done allow direct withdrawal (simplest form I can think of now)

        // if timer finished, then withdraw, then once withdraw succesfully, revoke membership (that might be a tricky one in terms of
        //  order and the access control you've implemented that way... anyway do it like that for now)

        //change status to non-member:
        membershipStatus[_member] = false;

        //events: withdraw success or not, and then membership stopped 
        emit WithdrawSafeDeposit(msg.sender, true);
    }

    // function getPooledRfCamount(uint256 _RfCid) public view returns(uint256 rfcPoolAmount) {
    //     // TO DO
    // }

    // function allocateFundsToRfC(address _user,uint256 _id, uint256 _startDepositTimer) public onlyMember returns(uint256 totalAmount) {
    //     //TO DO
        
    // }

    // again by seting the scope to private I only allow a function from this contract (does not mean it can't be abused if not careful...)
    //  => merge function logic w/ invest and safedeposit => then get rid of it
    function lockSafeDeposit(address _user) private  onlyFMProxy nonReentrant {
        require(safeDepositMade[_user] != true, "The security deposit is already met");

        // >>>> check the conversion MIN_ESCROW_TIME to unix time so no bug:
        if (block.timestamp - MIN_ESCROW_TIME >= memberSafeDepositStartTime[_user]) {
            locked = true;
            safeDepositMade[_user] = true;
            balance[address(this)] += 0.1 ether;
        }
        else {
            locked = false;
            revert();   // I guess that would be enough? Trying to get an err that bubbles up to the iuser though
        }

    }

    function redeemInvestorsReward()external onlyMember {}

    function redeemCPsReward() external onlyCP {}

    //specific withdraw (ACTUALLY make it for both cases): when the RfC doesn't pass the investors vote (time of deposit for investors who vote with ether +
    //  15 days):
    function withdrawFromEscrow(address _account,/* uint256 _amount,*/ uint256 _matureTime, uint256 _rfcId) external onlyMember withdrawApproved nonReentrant {
        require(_matureTime >= block.timestamp, "Escrow period not expired.");  // calculate the 30 days: time of deposit
                                                                                 // (should be recorded in a state variable, like block.timestamp f the tx)
                                                                                 // + 30 days (in linux time format)
                                                                                 // check withdrawApproved to implement part of requirements

        //that's a case requiring a burn feature:
        //rfcInstanceContract.burnRfCInCaseNotPassed(_rfcId);

        
        //(bool success, bytes data) = msg.sender.call{value: amount}("");

        // contract balance updated followed by user
        balance[ address(this)] -= investorAmountToSpecificRfC[_account][_rfcId];
        balance[_account] += investorAmountToSpecificRfC[_account][_rfcId];
        //require(success, "Transfer failed.");

        emit InvestmentRedeemed(_account, _rfcId, investorAmountToSpecificRfC[_account][_rfcId]);
    }

    function depositPayAccessContent(uint256 _rfcId, uint256 _amount) external onlyMember nonReentrant {
        //as investors have shares to a content they produce (that they can eventually sell to other users,
        //  but that will change their status back ti users, or RfCIdInvestor = false), they 
        //  will call another function to access content, if needed, that encodes the logic of their shares
        //  in the content, etc. 
        require(membershipStatus[msg.sender] == true, "Any protocol's user must first make a safe deposit of 0.1 ether");
        require(investorAmountToSpecificRfC[msg.sender][_rfcId] == 0, "The user has already invested in this RfC, then he/she/they don't need an to pay to access the content");

        //should return a token that gives them all data/authorization to access content
        //mintContentAccess();
    } 

    //Content shares Market through escrow and shares tracking + ERC20 wrapper allowinf the trade of shares on future content revenues
    function sellRfCShares(uint256 _rfcId, uint256 _sharesERC20) external onlyMember returns(uint256 amount) {

    }

    function buyRfCShares()external onlyMember returns(uint256 amount) {
        
    }

    /** Interactions with RequestForContent contract: **/

    // likely replaced by the Counter contract inherited from openzeppelin
    // function getRfCid(address _investorOrCP) external returns (uint256){
        
    //     return rfcInstanceContract.getRfCTracker();
    // }

    function setRfCIdFund(uint256 _id) public {
        //sum of all investors' deposits for a certain RfC
        
    }

    function commitFundsToRfC(address _user, uint256 _rfcId, address _rfcTokenAddr, uint256 _amount) internal returns (uint256) {
        // way to lock/commit an amount to a specific NFT

        // make sure the user authorize a certain amount 
        investorAmountToSpecificRfC[_user][_rfcId] -= _amount;
        
        //sum of all funds allocated to an RfC token:
        rfcNFTTokenIdFundAmount[_rfcTokenAddr][_rfcId] += _amount;

        //calculate unlockdate:
        maturationTime[_user] = memberSafeDepositStartTime[_user] + 60 days + MIN_ESCROW_TIME;  // investing in a content production lead to vest investmenet on 3 months
                                                                                                    // ideally, part of it will be unlocked progressively on the timeline of the content delivery

        emit FundsCommittedToRfC(_user, _rfcId, maturationTime[_user]);

        return rfcNFTTokenIdFundAmount[_rfcTokenAddr][_rfcId];
    }

}