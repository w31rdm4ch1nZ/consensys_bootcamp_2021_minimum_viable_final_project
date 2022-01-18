//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/token/ERC1155/IERC1155.sol';
import '@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol';
import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import './RequestForContent.sol';

contract InvestorsEscrow {
    //as I will limit my use in this contract to ether, maybe it is not useful - but surely it will for the core contracts such as FundsManager
    using SafeERC20 for IERC20;
    
    /*>>>>> MAKING SURE THIS ESCROW CONTRACT CALLS AND IS CALLED ONLY BY THE ACTUAL INSTANCES OF OUR PROTOCOL's CONTRACT:
            address public immutable FundsManagerCore = "{address of the contract acting as PCV and all content related >>funding<< logic}"; 
     <<<<<<
    */



    /** >>>>>>>>>>>>>>>>>>>>>>>>>>>>>USER INITIATING PROPOSAL<<<<<<<<<<<<<<<<<<<<<<<<<<<<< **/

    /** MAYBE SIMPLER TO ACTUALLY Merge all user types and txs types in the one core contract FundsManager **/

    /** >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>INVESTORS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<**/


    // a hold (to prevent abuses, spamming the CPs/participants) of 30 days on every deposit that initiates 
    // a proposal (on which can be made some yield profit)
    //  => won't affect users wanting to access content (and pay for it).
    
    // This constant is used for the proposal phase Investor transaction (another is used with a different time value, part of the RfC itself, for all other txs). 
    //  How do you target those transactions?:
    //  - RfCProposal
    //  - RfCCommitFunds (like a staking contract where investors stake some funds to signal both their interest in the RfC and the intensity of their interest
    //      with the amount they are willing to commit - one caveat that I want to prevent is that the shares in the RfC are eventually maipulable or
    //      subject to be defined by monopoly power. So I decide to define the shares on a content a la "quadratic voting")
    //  - ...
    
    uint256 public immutable MIN_ESCROW_TIME = 30 days; //check for how to set a duration/expiration time, etc.

    RequestForContent public RfC = RfC.address;
    uint256 RfCId;

    a value that says when a RfC is passes the proposal round and is now in "processing" (by a CP) status:
     => this value should be returned to this contract by the contract implementing the proposal logic
    bool public hasPassed = false;

    address public participant;

    bool public isInvestor;
    bool public initiaitesProposal;

    get an investor the authorization to the protocol to use a certain amount 
    (the amount the user-investor sent) 
    mapping(address => mapping(address => uint)) public allowance;

    mapping (address => uint256) public balance;

    mapping (address => mapping(uint256 => bool)) public fundsErrorToReturn;    //function executed every 30 days

    just want to be able to have a get function to query balance investors related to a RfC ID for the user 
     to have access to this information => could be a uint returned before funds are pulled by FundsManager
     contract for a specific RfC id
    /*
    mapping (address => uint256) public balanceInvestorsPool;

    uint256 investorFundsPooled;

    uint256 investorPoolShare;

    uint256 PoolId; // which will be the same as an RfCId, so choose one of those 

    mapping (address => bool) public isInvestor;
    
    initialized only if RfC is passed
    struct RfCBalance {
        uint256 RfCId; 
        uint256 amountRfC;
        uint256 time;       //not sure needed => would record the amount of funding for an RfC at a given time
    }

    RfC proposition exists under the form of a dynamic array built through the frontend. It is not a token minted as I don't want individuals
     to have to pay for minting a proposal - think of my use case for a "crowdjournalism" application.
         => maybe for now, keep the generic aspect, and just mint the token... (you can think of the specific use case of crowdjournalism for
         the next iteration)
    RfC public rfc;
    uint256 public rfcId;

    specific to this contract is the matureTime - if in the context of a proposition, then matureTime should be of RfC proposal to CPs phase
    minimum/standard (for now) duration + a hold (to prevent abuses, spamming the CPs/participants) of 30 days hold on it (on which can be made some yield profit - TBD if 
    those go to the procotol only, or some are given back to the user initiating a proposal) => matureTime moved to RfCProposal contract.
    

    mapping (address => bool) public userHasADeposit;

    keep track of the authorization by users for the protocol to uise their funds
    mapping (address => mapping (uint256 => bool)) private userProtocolFMAuthorization;

    "Protocol allowing" users to withdraw their funds, according to different conditions to be satisfied, depending on the role the user is playing at a certain 
    time and under certain conditions => the controls are hendled on the Protocol contracts side, not here. Here, we have a state variable (that is set
    on the protocol side) from which we can infer an authorization to withdraw funds for a user
    mapping (address => bool) public protocolUserWithdrawAuthorization;

    modifiers

    modifier onlyInvestor{
        require(isInvestor[msg.sender] == true, "is not an investor");
        _;
    }
    */

    /*
    modifier initiatesProposal{
        require(RfCId == nextValidRfCId, "is not a valid RfCId");
        require(initiaitesProposal == true, "has not initiated proposal");
        _;
    }
    */

    /*
    modifier transferFMonlyOnceAllowed{
        require();
        _;
    }
    */
    
    events
    /*
    event Deposit(address indexed _from, uint _value);

    event Escrowed(address _from, address _to, uint256 _amount, uint256 _matureTime);

    event ProtocolAllowed(bool indexed allowanceUserValidation, uint amountDAI);

    event Initialized(address _mintedRfC);

    event DepositForProposal(address depositor, uint256 proposalId, uint256 rfc);
    
    constructor(){

        investorEscrowInstance = new InvestorEscrow;
        cpsEsrowInstance = new ContentProviderEscrow;
        fmCurrentInstance = new FundsManager;
        Check Permissions pattern in the FEI protocol code
        _setContractAdminRole(keccak256("INVESTORESCROW_ADMIN_ROLE"));  // a multisg-wallet with 1 3rd 
                                                                        controlled by previous users of the protocol
    }
    
    
    receive funds from users wanting to particpate to the content market making protocol 
    => likely better to have a specific deposit function for each
     investor's use case (that then they can call from the web UI, making sure they do 
     knowingly sen their funds for a specific action in the protocol)
    
    Returns balance of InvestorEscrow contract
    function getBalance() public returns(uint){
        return address(this).balance;
    }

    Returns balance of TransferEtherTo contract
    function getBalanceFMInstance() public returns(uint){
        return fmCurrentInstance.getBalance();
    }
    
    function investorsDeposit() public payable returns(bool success) {
 
        require(balance[msg.sender] >= msg.value, "user doesn't have emough funds => revert");

        balance[address(this)] += msg.value;
        
        call a function defined either in this contract as "internal" call, or in the FundsManager contract
        _lockFunds(msg.sender);

        emit Deposit(msg.sender, msg.value);
        
        isInvestor = true;
        emit Escrowed(msg.sender, adress(this), msg.value, _matureTime);

        return true;
    }

    function initiateProposal(uint256 _id) external payable {
        amount must cover minting RfC token + staked tokens to be locked for 30 days (amount TBD) 
        require()

        
    }

    Transfers ether to InvestorsEscrow contract
    function transfer() internal payable onlyInvestor {
        setApprovalForAll(operator, approved);
        address(fmCurrentInstance).send(msg.value);
    }






    >>>EDGE CASE(not necessary for now<<< 
     in case of an error not handled correctly (funds send accidentally to the escrow and tx not reversed),
     gets the funds in the FundsManager contract:
     Fallback function to receive and transfer Ether to the core contract
    fallback() external payable {

        address(fmCurrentInstance).send(msg.value);
    }
    
    /*
    function getnextValidRfCId(uint256 _id) public view returns(bool) {
        require(_id == RfCId + 1, "not a valid new proposal id");
        return true;
    }
    */

    /** >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>CONTENT PROVIDERS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< **/




    /** >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>USERS ACCESSING CONTENT ONCE CREATED<<<<<<<<<<<<<<<<<<<<<<< **/

    //function where users give approval to the FundsManager contract to withdraw their funds from this escrow
    // contract => spender = FundsManager contract address on your testnet - make sure it can only authorizes
    // the actual instance of your contract (through authorization roles pattern defined in the AccessControl 
    // contract)
    function _approve(address owner/*,address spender, uint256 value*/) private {

        //value = msg.value;

        //owner is the role defined by us having rights on this contract (admin of the escrow for pausing emergency,
        //  or emergency transfer of the funds, ..? => it should be a multi-sig contract, where at least one of
        //  the required key is another contract controlled by some of the investors (a few of them
        //  are assigned randomly this role, done each time for a new RfC => TO DO: next iteration, where I'll go deeper
        // in multi-sig control over EOA and contracts, and how to compose with it))

        require(owner == INVESTORESCROW_ADMIN_ROLE);    // make sure only FundsManager can be allowed to 
                                                        // manage the funds.

        //owner is a multi-sig contract, that can send the funds to the spender (see where the value is accessed
        //  maybe again in FundsManager), our FundsManager contract:
        // spender is actually assigned inside the FundsManager contract as address(this), where this function 
        //  is defined:
        _safeTransfer(owner, value);
        
        setApprovalForAll(operator, true);
    }

    /** 
    function transferFrom(address from, address to, uint value) external returns (bool) {
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _transfer(from, to, value);
        return true;
    }
    **/

    function lockFunds(address investor, uint256 _timeMaturity) internal {
        //Check pattern usually used for this purpose (as a resting time before actual unstaking happeing for instance)
    }

    function depositForRfCProposal(RfCProposal _rfcProposal,uint256 _RfCProposalID) public {
        require(isInitiated[_RfCProposalID] != true, "Is already in proposal phase");    // might add the case where an exact same proposal 
                                                                                        //  (so all proposal would be kept in a special RfCPrposalEscrow contract)
                                                                                        // can't be reproposed as is => give it some thinking....?
        emit DepositForProposal(msg.sender, proposalId, rfcId);
    }

    //function in which is called (or implemented in) a quadratic voting function + assign Investor role to the user + add sent amount to escrow balance
    // to be withdrawn by the Protocol FundsManager core contract
    //>>>>>>>>FOR NOW, V2
    function depositForRfCInvestorValidation() public payable returns (hasPassed, RfCId){
        //TO DO (V2, or once you've done the minimal mechanics)
        
        //require

        //set role
        //isInvestor[msg.sender] = true;

        //set authorization for FundsManager contract to withdraw the funds

            // => Once added to the investor Pool, in FundsManager contract, it triggers a call to mint a (dynamic) NFT representing the share of the investor in the pool

        // 

    }

    function depositPayAccessContent(uint256 _RfCId, uint256 _amount) external {
        //as investors have shares to a content they produce (that they can eventually sell to other users,
        //  but that will change their status back ti users, or RfCIdInvestor = false), they 
        //  will call another function to access content, if needed, that encodes the logic of their shares
        //  in the content, etc. 
        require(msg.sender != Investor, "investors in this RfC should access this content through their dashboard");

        //should return a token that gives them all data/authorization to access content
    } 

    //Specific to CPs answering to a proposal, to manifest their interest in producing/creating this content.
    // It interacts with a reverse auction contract that
    //  itself is meant to achieve in the best (trustless and efficient trade-off acceptable) possible way 
    //  the coordination between investors and CPs.
    //      => solve this pb now: how investors and CPs "agree"/coordinate on the funding amount 
    //  for a given RfC?:

    /** 
        >>>>>>>>
        IMPORTANT TO NOTE: AT THIS POINT, I HAVE NOT FORMULATED ANYTHING THAT WOULD RULE OUT FROM MY
        PROPOSAL ROUND AND THE QUADRATIC VOTING  A SIMPLE SYBIL ATTACK (multiple account owned by one entity)
            => it would require something like Proof of humanity od a DID service.
        <<<<<<<< 
        
        - 1 possibility (complex I think... as I don't think, of any other way than doing it through 
        some sort of zk-proof scheme -> could search if "simple" implementation of that for a vote on the web?): 
            -> a sort of "silent reverse auction" where the CPs don't know the max amount investors are ready 
            to commit for one RfC, and the investors don't know the min amount for which CPs are ready to accept 
            to commit to deliver the Content/Product.
                => what would be precisely this mechanism?
                    - each participants commits a max investment amount they commit to put under escrow (but don't do yet so it stays secret, but also
                        that have to force them to then commit for the minEscrowTime if the outcome is a miss);
                    - each willing Content Provider commits a min amount for which they would accept to create and distribute/make accessible the content;
                        => an auction mechanism starts with a minimum amount publicly defined in the RfCProposal where investors can "enter" multiple times/
                        signal their interest (canceling the previous bid with the highest at a given time - they have the possibility to
                        predetermine their maximum and so the auction goes for the remaining investors and the CPs), and the CPs can choose to commit
                        to an amount, which in our proptocol binds them to deliver the content and be rewarded for it, or being punished by losing part or all of their 
                        escrowed funds.  
                => how to implement such a mechanism? (cf. https://eprint.iacr.org/2018/704.pdf for most of the elements defined fromally in pseudo-code)

                    => I actually might be able to implement a quadratic voting and secret auction as I want with the AztecProtocol SDK:
                    https://docs.aztecprotocol.com/#/Introduction

                    Now maybe I'll keep that part for the iteration 2.
                    It could mean 2 things:
                        - either I entirely skip this RfC proposal validation process/round, and on a very simplified set of assumptions (about participants, 
                        from errors to malevolent behaviors, and about decentralized coordination), and I go straight to RfC to be minted (which will also 
                        imply that investors are comitting the same amount - or that kind of simplification);
                        - or I ignore the private/zk-proof-commit/secret required for the mechanims to actually work in the wild (and not be gamed by CPs observing 
                        investors transactions and same for investors). In this case I just keep the quadratic voting + the auction (described above) implementation.
                            => it would remain an interesting challenge for me...

                    => further elaborating on the auction structure for the CPs: I would choose a reverse Vickerey auction, also called "second-price auctions",
                    because that would induce in the auction a configuration that makes CPs more careful about trying to accept at the lowest possible value
                    a commit to RfC. Why? Because, in the end it is in the overall interest to have a Content DELIVERED, and one of the thing that could happen
                    is to have CPs to be incentivized at the proposal moment to accept low funding resulting in low quality of content or excessive rate
                    of undeilvered contents. So second lowest commit will win. 

    **/

    function getRfCStatus(RfCId) public view returns(bool) {
        _RfCStatus(RfCId);
    }
    function depositForRfCCPValidation() public payable {

    }

    //an authorization function that makes users accepting the protocol to use their funds => handled through metamask and web3.js => check if one exists in
    // ERC1155 standard
    function userProtocolFundsAllowance(address _account, uint _amount) public {
        
        //user allows protocol to use their deposit amount
        userProtocolWithdrawAuthorization[_account] = true;

        emit ProtocolAllowed(_account, balance[_account]);
    }

    //withdraw their funds

    //in case those funds were allocated to an RfC that did not pass the proposition phase (under this layer, so you can ignore this logic in this contract
    //   - as the funds are always pooled, it eventually always imply an NFT tracking the pool share of an account (and possibly under the hood 
    // the cToken interactions, etc. - but abstracted away from this contract):
    
    /**
    function withdrawFromEscrow(address _account, uint256 _amount) external {
        require(= msg.sender, "Must own token to claim underlying Eth");

        (uint256 amount, uint256 matureTime) = escrowNFT.tokenDetails(_tokenId);
        require(matureTime <= block.timestamp, "Escrow period not expired.");

        escrowNFT.burn(_tokenId);

        (bool success, ) = msg.sender.call{value: amount}("");

        require(success, "Transfer failed.");

        emit Redeemed(msg.sender, amount);
    }

    **/

    // a protocol authorization previous to any withdraw (above function) to be successfull
    //      require(unlock) 
    //      require(time >= maturationTime)
    //      require(_amount <= balance[msg.sender])

    //ROLE AUTHORIZATION TBD: withraw funds for the protocol FundsManager core contracts 
    // => specifically its address and no one else (no other ethereum account)
    // should be able to withdraw those funds

    //recieve funds from the Protocol:

    //functions to read (get()) the balances of the different accounts interacting with this contract, and this contract's balance


    //function giving contract addresses from this contract (used mainly for frontend interaction and debug/tests) => I'll see if I add a way to get
    // other core protocol contract addresses
    function contractAddress() public view returns (address) {
        return address(this);
    }

  
}
