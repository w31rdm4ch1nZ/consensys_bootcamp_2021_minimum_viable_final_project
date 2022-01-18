/*
    just in its simplest form:
        - want 1st to manage to send funds from Escrow contract to this contract (nothing fancier);

*/

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract FundsManager {

    address public user;
    
    uint256 public contractBalance; // by default can be accessed by this.balance, or something like that
    
    uint256 private amount;

    bool private locked;

    mapping (address => mapping (uint256 => bool)) userHasSecurityDeposit;

    uint256 public shareOfRfCOwnership;

    uint256 private ratio;

    mapping (address => mapping(uint256 => uint256)) public shareRatioOfRfC; 



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

    modifier onlyFundsManager{
        require(user == address(this), "This sate modification can only be triggered by the FundsManager contract.");
        _;
    }

    constructor()  {
        //test pre-game (to disappear)
        
        //Define roles of the pattern access control
        // TO DO

        //instantiates the other contracts
        RequestForContent RfC = new RequestForContent();

    }

    //Returns balance of InvestorEscrow contract
    function getContractBalance() public view returns(uint){
        return address(this).balance;
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
    fallback() external payable {
        
    }

    receive() external payable {
        userType = ParticipantType.isInvestor;

        //increment contract balance
        contractBalance += msg.value;
    }


}