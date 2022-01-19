import MetaMaskOnboarding from '@metamask/onboarding'


const currentUrl = new URL(window.location.href)
const forwarderOrigin = 'http://127.0.0.1:5501'

  //Created check function to see if the MetaMask extension is installed
  const isMetaMaskInstalled = () => {
    //Have to check the ethereum binding on the window object to see if it's installed
    const { ethereum } = window;
    return Boolean(ethereum && ethereum.isMetaMask);
  };


  // Dapp Status Section
  const networkDiv = document.getElementById('network')
  const chainIdDiv = document.getElementById('chainId')
  const accountsDiv = document.getElementById('accounts')

  // Basic Actions Section
  const onboardButton = document.getElementById('connectButton')
  const getAccountsButton = document.getElementById('getAccounts')
  const getAccountsResults = document.getElementById('getAccountsResult')

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

  // Investor Dashboard Section
  const idRfC = document.getElementById('RfCid')
  const investEth = document.getElementById('amountInvestedEth')
  const investButton = document.getElementById('investButton')  // call function in FundsManager contract with parameters passed

  // Display information regarding your investment in a Request for Content:
  //  Implies to read states form the contracts + updates with events in the contract:
  const investmentsList = document.getElementById('investmentsList')  //to add in the frontend
  const inputRFCidToDisplay = document.getElementById('RfCidToDisplay')
  const displayInvestmentInfoButton = document.getElementById('displayInvestmentInfoButton')

const initialize = () => {
  //You will start here 
  //const onboardButton = document.getElementById('connectButton');

  let accounts
  let fundsManagerContract
  let requestForContentContract
  // other contracts needed
  let accountButtonsInitialized = false
 
  const accountButtons = [
    sendButton,
    investButton,
    displayInvestmentInfoButton,
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

  const MetaMaskClientCheck = () => {
    //Now we check to see if MetaMask is installed
    if (!isMetaMaskInstalled()) {
      //If it isn't installed we ask the user to click to install it
      onboardButton.innerText = 'Click here to install MetaMask!';
      //When the button is clicked we call this function
      onboardButton.onclick = onClickInstall;
      //The button is now disabled
      onboardButton.disabled = false;
    } else {
      //If it is installed we change our button text (would be great to have it displaying the account's address...)
      onboardButton.innerText = 'Connected to Ethereum';
      //When the button is clicked we call this function to connect the users MetaMask Wallet
      onboardButton.onclick = onClickConnect;
      //The button is now disabled
      onboardButton.disabled = false;
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

    /**
     * Contract Interactions
     */

    //fundsManagerContract = web3.eth.contract([{
    //then, requestForContentContract = web3.eth.contract([{}])

    // an authorization given by the user to use his Eth

    /**
     * Sending ETH
     */

    sendButton.onclick = () => {
      web3.eth.sendTransaction({
        from: accounts[0],
        to: /*fundsManagerContract address*/0x9F9b47D1c380e94a35332866a7ad67abE0536AFF,
        value: '0x29a2241af62c0000',
        gas: 21000,
        gasPrice: 20000000000,
      }, (result) => {
        console.log(result)
      })
    }
  


  // //Eth_Accounts-getAccountsButton
  // getAccountsButton.addEventListener('click', async () => {
  //   //we use eth_accounts because it returns a list of addresses owned by us.
  //   const accounts = await ethereum.request({ method: 'eth_accounts' });
  //   //We take the first address in the array of addresses and display it
  //   getAccountsResult.innerHTML = accounts[0] || 'Not able to get accounts';
  // });

  // getAccountsButton.onclick = async () => {
  //   try {
  //     const _accounts = await ethereum.request({
  //       method: 'eth_accounts',
  //     })
  //     getAccountsResults.innerHTML = _accounts[0] || 'Not able to get accounts'
  //   } catch (err) {
  //     console.error(err)
  //     getAccountsResults.innerHTML = `Error: ${err.message}`
  //   }
  // }

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



window.addEventListener('DOMContentLoaded', initialize)
