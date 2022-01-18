//import MetaMaskOnboarding from '@metamask/onboarding'

const forwarderOrigin = 'http://127.0.0.1:5500'

const initialize = () => {
  //You will start here 
  const onboardButton = document.getElementById('connectButton');

  //Created check function to see if the MetaMask extension is installed
  const isMetaMaskInstalled = () => {
    //Have to check the ethereum binding on the window object to see if it's installed
    const { ethereum } = window;
    return Boolean(ethereum && ethereum.isMetaMask);
  };

  //We create a new MetaMask onboarding object to use in our app
  //const onboarding = new MetaMaskOnboarding({ forwarderOrigin });

  //This will start the onboarding proccess
  // const onClickInstall = () => {
  //   onboardButton.innerText = 'Onboarding in progress';
  //   onboardButton.disabled = true;
  //   //On this object we have startOnboarding which will start the onboarding process for our end user
  //   onboarding.startOnboarding();
  // };  

  const onClickConnect = async () => {
    try {
      // Will open the MetaMask UI
      // You should disable this button while the request is pending!
      await ethereum.request({ method: 'eth_requestAccounts' });
    } catch (error) {
      console.error(error);
    }
  };

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
      //If it is installed we change our button text
      onboardButton.innerText = 'Connect';
      //When the button is clicked we call this function to connect the users MetaMask Wallet
      onboardButton.onclick = onClickConnect;
      //The button is now disabled
      onboardButton.disabled = false;
    }
  };
  MetaMaskClientCheck();
}

/** 
 * 
 * investors' dashboard specific transactions and interactions:
 *  - verify connected
 *  - make a proposal: tx that will include inputs 
 * from the frontend (=all multiple choices lists of elements 
 *    resulting in an RfC as defined in the .sol contract)
 *      => - send ether + data for RfC components +
 *        in the backend (contracts), it triggers mint() of the RfC (an NFT minted through the ERC1155
 *        API (if pases all checks, starting with inputs being part of the possible states/RfC components)
 *        => it means having the possible inputs defined in the investor dashboard (drop lists).
 *  
**/

window.addEventListener('DOMContentLoaded', initialize)
