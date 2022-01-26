// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;


/** Simplify: make it ERC-721 instead of ERC-1155 for now **/
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Arrays.sol";

// for defining role-based access control:
import "@openzeppelin/contracts/access/Roles.sol";


contract RequestForContent is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {          

    using Counters for Counters.Counter;
    using SafeMath for uint256;
    using Roles for Roles.Role;

    Counters.Counter private _tokenIdTracker;

    Roles.Role private _minters;
    // It is a role that is aimed at allowing FundsManager contract to make calls, avoiding any direct users and others (potentially malicious contract)
    //  to call the functions on which I define a modifier to only allow this role to be the caller:
    Roles.Role private _approvedFundsManagerInstance;

    address private caller;

    uint256 private fundsPooledForRfC;  // should be set after mint...? (because unknown at proposal)

    uint256 public allocatedBudgetForPC; // see if you tokenize this (probably)

    mapping (address => mapping(address => uint256)) public trackFundsUseByCP; // see if doable in a simple way for now

    //FundsManager fundsManager /* = address of contract deployed on the testnet*/;

    /**
    *
    *   
    *   REQUEST FOR CONTENT ELEMENTS OF DEFINITION => just a sketch at this step 
    *   (will include on-chain Proofs, etc. to increase trustless aspect, and decrease ways for CPs to cheat, 
    *   or anticipate on most possible disagreements)
    *
    * 
    **/

    //(Phases/Cycles/Steps/)**Components that can translated *unambiguously* in a requirement** for the Content delivery:

    enum DeliveryStatus {
        investorsVote,
        cancelled,  //can happen at several stage on a mechanism of coordination between investors (that you might not implement
                    // for this iteration)
        mintedRfC,
        CPsProposition,
        contentInProduction, // pendingDelivery (?)
        contentDelivered,
        qualityEvaluation,  // not sure I will implement any mechanism fo that at this point   
        contentAccepted,    //triggers the CP(s) payment
        contentRefusedAsIs, // starts a new proposition for CP(s) (either calling the function "contentEnrichment()", or resets
                            // to CPsProposition step (it avoids cost of new minting and the cost of the compounded Yield assotiated 
                            // operations))
        contentAccessibleByInvestors,
        contentAccessForEveryone,
        //...,
        unknown
    }

    DeliveryStatus RfCRoundStatus;

    //>>>>>>Request for Content tokenization definition - check the way Gnosis tokenizes its "rich-logic/data tokens":<<<<<<<<\\


    //mandatory
    enum When {
        Live,
        Stored,
        Archived
    }

    When when;

    enum ContentMediumDelivered {
        NFT,
        Stream,
        Video,
        Audio,
        Article,
        Software,
        //...,
        undefined               // => just used to disqualified a proposal before it reaches the proposal round (there will be also a grey/uncliclable 
                                // are as long as the proposal don't include this mandatory field)
    }

    ContentMediumDelivered contentMedium;

        // => result which could be passed in a tx from the frontend would be a value that triggers a certain call among the ERC1155 functions:
        //  _mint(), and with more time (TO DO), more complex integrations like call to mint an NFT of a LivePeer video feed, etc.

    //optional for definition from the user and the minting of an RfC(not for the CP)
    enum ContentDigitalFileFormats {
        EthBlock,
        EthTx,
        jpg,
        gif,
        raw,
        svg,
        mp4,
        mp3,
        ogg,
        txt,
        pdf,
        latex,
        css,
        html,
        javascript,
        typescript,
        rust,
        WindowsExe,
        LinuxApp,
        dockerizedImage,
        //...,
        undefined
    }
        // => result: add a component (that can be split later if necessary) to the RfC tokenized set of requirements
    ContentDigitalFileFormats fileFormat;

    //optional
    enum PlatformCompatibilityAtDelivery {
        OpenSea,
        LivePeer,
        Audius,
        Filecoin,
        Arweave,
        Siacoin,
        //...,
        undefined
    }

    PlatformCompatibilityAtDelivery integratedTo;    

    //mandatory
    enum StoragePlatformUsedToDeliverContent {
        EthBlocks,
        IPFS,
        Arweave,
        Siacoin,
        OpenSea,
        LivePeer,
        Audius,
        AWS,
        Azure,
        //...,
        undefined
    }

    StoragePlatformUsedToDeliverContent storageSolution;

    // optional => can be forgotten for the purpose of this final project (just an exemple of how multiple use cases could be integrated in the protocol)
    enum dataAPIToBeUsed {
        Google,
        GoogleMap,
        TheGraph,
        //...,
        undefined
    }

    dataAPIToBeUsed apiUsed;

    //mandatory => define further and more clearly the use of this choice of collateral => and maybe it will require more fields if it 
    // has to be decided for several uses in the protocol
    enum ContentIsRedeemableFor {
        ETH,
        WETH,
        wFIL,
        WBTC,
        LVP,
        //...,
        USDT,
        wUST,
        DAI,
        DecentralandIsland,
        SandboxSpace
    } 

    ContentIsRedeemableFor contentRedeemableFor; 

    uint256 public timeForDelivery;


    // Set arrays with values from enums passed (and checked for validity) from web3/MM tx 
    //The RfC struct, leading to the set of components and properties to be eventually tokenized as representing the request for content
    
    struct RequestForContentStruct {
        //Define 1st the "mandatory" fields (for the RfC to even be considered to be proposed )
        // set arrays with possibly several values of one enum
        string[] contentTimeRequirements;
        string[] media;
        string[] storageSolutions;
        string[] fileFormats;
        string[] contentIntegrations;
        string[] redeemableFor;
        //...;
        //Properties[] RfCProperties;
    }

    //read function of te struct to extract offsets for properties, and metadata to be used, like length, etc.
    // function readRfCStruct(RequestForContent RfC) internal returns(int256 length, uint256[] proertiesOffsets, ..?) {
    //     //TO DO
    // }

    event RfCProposal();

    event RfCMinted();

    //event RfCCPselected();


    //Set a RfC structure (built with inputs from the Proposer) to enter the proposal to CPs cycle will require from investors to commit funds/send funds to the escrow 
    // contract

    //RfC struct has to pass some basic conditions: => make those part of your tests (?)
    // length != null
    // length > 0 
    // components <= 256 (check if data type like struct can have more elements??)
    // controls on the mandatory fields (to be defined in your contract - eg. at least one contentType, etc.) 

     //modifiers:

    modifier OnlyApprovedAcccounts{
        require(caller = _approvedFundsManagerInstance, "caller is not authorized");
        _;
    }

    event SucessfullyMinted(address RfC, uint256 id, uint256 time);

    constructor() ERC721("RequestForContent", "RFC") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://blabla_masterpiece_genart_by_supadupaNFTstar.mp4";
    }


    function safeMint(address to) external onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        emit SucessfullyMinted(to, tokenId, now);   // "now" gives the time in unix standard = make a conversion in your js
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }


    /** 
    
        >>>CHECK what you should keep, as what precedes are the standard functions of NFTs (=> OpenZeppelin Contracts Wizard)<<<
    
    **/

    function setEnums(uint256 _data) internal {
        // Find a way (simpler) than with offsets in bytes, but if necessary... do it
        //contentTimeRequirements = ...; 
    }

    /** ==>>> NEW IDEA TO IMPLEMENT THE "Check the values for RfC to be valid, and then only minted... <<<=== **/
    // You likely should use the utils/Arrays.sol OpenZeppelin contract to iterate (knowing they will have minimize space and gas overhead):
    //  adding import "@openzeppelin/contracts/utils/Arrays.sol"; => and then takes the values sent through the frontend (or better: 
    //  update the frontend listing with the values of your smart contract! => the limited set that the protocol integrates at a given time and that
    //  protocol's particpants can use to define an RfC)
    function setRfCForMint() internal /**returns (RequestForContentStruct RfC)**/ {

        //cf. above: TO DO

        // set struct with the values set in setEnums:
        RequestForContentStruct.When = when;
        RequestForContentStruct.ContentTypeDelivered = _contentType;
        //...

    } 

        // =>>>>> USE THIS struct states to avoid 2 mints and keep this track state during the CP silent auction

    // Then, once CP selected, mint it (wit the info like fundsAllocated, etc. that allow to leverage ERC1155 possibilities):
    function setRfCReadyForMint(RequestForContentStruct RfC, bool isFunded, int256 fundsPooledInvestorsAmount, uint256 fundsPooledCPsAmount) external {

        //TO DO

        //NFT minted, incorporating the possibilities to be then splitted (as for Gnosis Conditional Tokens)
    }

    // //Following ERC1155 standard:
    // //minting the RfC => calls to ERC1155 contracts/interfaces (import them)
    // function mintRfC() external {
    //     //To do in order to check that the data from the transaction coming are in the set of RfC valid inputs => loop through the enum (or
    //     //  anything more efficient/involving less computation ops...)

    //     _mint(toRfCEscrow, RfCId,  )

    // }

    //called in mint function (probably?)
    function collaterlizedRfCMint() internal  {
        //TO DO
    }

    function reportRfCPayouts() external {
        //TO DO
    }

    // QUESTION: in FundsManager contract or here??
    //comparable to the split function in the Gnosis Conditional Token contract:
    function burnSharesNFTforERC20(address _contentCreationOG, uint256 _contentPrice/**, anything else? **/ ) external returns(bool success) {
        //TO DO: allow investors to sell their shares for some ERC20 stablecoin(DAI)/Eth

    }

    // // Lkely not to be implemented in this iteration
    // //for readability and clarity (in function call for instance), separate the function below from the one adding new elements:
    // function addNewElToRfC() internal {
    //     //TO DO: enrich an existing RfC by adding richer content/properties (eg. might be interesting if it is a software or an investigative article)
    // }

}
