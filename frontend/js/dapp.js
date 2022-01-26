var Web3 = require('web3');

var web3 = new Web3("ws://127.0.0.1:8545" || "https://ropsten.infura.io/v3/" + INFURA_ID);

var fmContract = new web3.eth.Contract(jsonInterfaceFM, addressFM);
var rfcContract = new web3.eth.Contract(jsonInterfaceRfC, addressRfC);
//var voteContract = new web3.eth.Contract(jsonInterfaceVote, addressVote);
//var contentSharesERC20Contract = new web3.eth.Contract(jsonInterfaceERC20, addressERC20); 

// To define once deployed on the testnet of your choice:
//abi = 
// address =

var eth = new Web3.eth.Contract(abi, ETH);

let accounts



// Safe deposit (required for all users to have their txs accepted/interact with the protocol)
const membershipActiveStatusHTML = document.getElementById('membershipActiveStatus');
const safetyDepositSubmit = document.getElementById('safetyDeposit');
const membershipActiveStatus = document.getElementById('membershipActiveStatus');

const requiredEthForSD = await myContract.getRequireSDAmount().call()[0];
const requiredEthForSD = 0.1;
const sendEth = requiredEthForSD * 1.1;      // to force to send slightly more than the estimate to limit reverted txs


const ethEnabled = async () => {
  if (window.ethereum) {
    await window.ethereum.request({method: 'eth_requestAccounts'});
    window.web3 = new Web3(window.ethereum);
    return true;
  }
  return false;
}


async function getAccount() {
  accounts = await ethereum.request({ method: 'eth_requestAccounts' });
}

const initialize = () => {
  //You will start here 
  const onboardButton = document.getElementById('connectButton');



  let accountButtonsInitialized = false

  const accountButtons = [
    getAccountsButton,
    safetyDepositSubmit,
    sendButton,
    investButton,
    displayInvestmentInfoButton
  ]

  const isMetaMaskConnected = () => accounts && accounts.length > 0

  const onClickConnect = async () => {
    try {
      const newAccounts = await ethereum.request({
        method: 'eth_requestAccounts',
      })
      handleNewAccounts(newAccounts)
    } catch (error) {
      console.error(error)
    }
  }

  const updateButtons = () => {
    const accountButtonsDisabled = !isMetaMaskInstalled() || !isMetaMaskConnected()
    if (accountButtonsDisabled) {
      for (const button of accountButtons) {
        button.disabled = true
      }
      
    } else {
      sendButton.disabled = false
      investButton.disabled = false
      displayInvestmentInfoButton.disabled = false
    }
    if (!isMetaMaskInstalled()) {
      onboardButton.innerText = 'Click here to install MetaMask!'
      onboardButton.onclick = onClickInstall
      onboardButton.disabled = false
    } else if (isMetaMaskConnected()) {
      onboardButton.innerText = 'Connected'
      onboardButton.disabled = true
      if (onboarding) {
        onboarding.stopOnboarding()
      }
    } else {
      onboardButton.innerText = 'Connect'
      onboardButton.onclick = onClickConnect
      onboardButton.disabled = false
    }
  }

  const initializeAccountButtons = () => {

  if (accountButtonsInitialized) {
    return
  }
  accountButtonsInitialized = true

  //Eth_Accounts-getAccountsButton
  getAccountsButton.onclick = async () => {
    try {
      const _accounts = await ethereum.request({
        method: 'eth_accounts',
      })
      getAccountsResults.innerHTML = _accounts[0] || 'Not able to get accounts'
    } catch (err) {
      console.error(err)
      getAccountsResults.innerHTML = `Error: ${err.message}`
    }
  }

  function handleNewAccounts (newAccounts) {
    accounts = newAccounts
    accountsDiv.innerHTML = accounts
    if (isMetaMaskConnected()) {
      initializeAccountButtons()
    }
    updateButtons()
  }

  function handleNewChain (chainId) {
    chainIdDiv.innerHTML = chainId
  }

  function handleNewNetwork (networkId) {
    networkDiv.innerHTML = networkId
  }

  async function getNetworkAndChainId () {
  try {
    const chainId = await ethereum.request({
      method: 'eth_chainId',
    })
    handleNewChain(chainId)

    const networkId = await ethereum.request({
      method: 'net_version',
    })
    handleNewNetwork(networkId)
  } catch (err) {
    console.error(err)
  }
  }

  updateButtons()

  if (isMetaMaskInstalled()) {

    ethereum.autoRefreshOnNetworkChange = false
    getNetworkAndChainId()

    ethereum.on('chainChanged', handleNewChain)
    ethereum.on('networkChanged', handleNewNetwork)
    ethereum.on('accountsChanged', handleNewAccounts)

    try {
      const newAccounts = await ethereum.request({
        method: 'eth_accounts',
      })
      handleNewAccounts(newAccounts)
    } catch (err) {
      console.error('Error on init when getting accounts', err)
    }
  }



  MetaMaskClientCheck();
}

  /**
 * Contract Interactions
 */




  //fundsManagerContract = web3.eth.contract([{
  //then, requestForContentContract = web3.eth.contract([{}])

  // an authorization given by the user to use his Eth

  /**
   * Sending ETH
   */
  var safetyDepositButon = document.getElementById('safetyDeposit') 



  safetyDepositButon.onclick = () => {
    web3.eth.sendTransaction({
      from: accounts[0],
      to: account[1], //For tests purposes => should be the address of FundsManager contract
      value: web3.utils.toHex(web3.utils.toWei('0.1', 'ether')), 
      gas: web3.utils.toHex(21000),
      gasPrice: web3.utils.toHex(web3.utils.toWei('10', 'Gwei')),
    }, (result) => {
      console.log(result)
    })
    //.then.
  }

  //init variables:
  function insertStatusMessage(statusString) {
  membershipActiveStatusHTML.innerHTML = statusString
  }

  safetyDepositSubmit.onclick = submitMMSafeDeposit;

  const submitMMSafeDeposit = () => {
    
    // call contract function to read if this account has already a safeDeposit in the FundsMananger contract,
    //  and if it is active or not (<=> already allocated to an RfC) // I could make the memebership/safety deposit decorrelated from this logic 
    //  of allocation to RfC...

    // Check if acount has already a 0.1 deposit locked in FundsManager:
    fmContract.methods.getSDstatus(accounts[0]).call((err, result) => {
      if (!result) {
        statusString = 'Membership inactive';
      }
      statusString = 'Already active';
      insertStatusMessage(statusString);
    }
    );

    //allow transfer of 0.1 to be signed by active user account
    fmContract.methods.approve(contractAddress, sendEth).send({from: userAddress}, 
      function(err, transactionHash) {
          //some code
    });

    
    //send 0.1 eth to FundsManager contract
    


    safetyDepositSubmit.disabled = true;
    insertStatusMessage('Membership active');
  }

  /****
   * 
   *  *  * REQUEST FOR CONTENT SECTION for RfC Dashboard
   *  
   ****/

  // Go to make a proposal
  const urlToRfCProposal = document.getElementById('goToRfCProposal')


  /****
   * 
   *  *  * CONTENT PROVIDER SECTION for CP Dashboard
   *  
   ****/

  /*
  const deployButton = document.getElementById('deployButton')
  const depositButton = document.getElementById('depositButton')
  const withdrawButton = document.getElementById('withdrawButton')
  const contractStatus = document.getElementById('contractStatus')
  */

  // Send Eth Section for Investor (pass the ID # of the RfC the user wants to invest in)
  const sendButton = document.getElementById('investRfCidX')


  /****
   *  
   * * * INVESTOR DASHBOARD SECTION for Investor Dashboard
   * 
   ****/

  


  const idRfC = document.getElementById('RfCid')
  const investEth = document.getElementById('amountInvestedEth')
  const investButton = document.getElementById('investButton')  // call function in FundsManager contract with parameters passed

  // Display information regarding your investment in a Request for Content:
  //  Implies to read states form the contracts + updates with events in the contract:
  const investmentsList = document.getElementById('investmentsList')  //to add in the frontend
  const inputRFCidToDisplay = document.getElementById('RfCidToDisplay')
  const displayInvestmentInfoButton = document.getElementById('displayInvestmentInfoButton')


window.addEventListener('DOMContentLoaded', initialize);
