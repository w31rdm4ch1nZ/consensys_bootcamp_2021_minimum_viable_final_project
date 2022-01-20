const Web3 = require('web3');
const web3 = new Web3("http//localhost:8545");

// To define once deployed on the testnet of your choice:
//abi = 
// address =

var contractRfC = new web3.eth.Contract(abi, address);


//To set date in smart-contract with web3.js:

let date = (new Date()).getTime();
let birthDateInUnixTimestamp = date / 1000;
await BirthDate.methods.set(birthDateInUnixTimestamp).send(opts);

//To get date from smart-contract with web3.js:

let birthDateInUnixTimestamp = await BirthDate.methods.get().call();
let date = new Date(birthDateInUnixTimestamp * 1000);


// cf. https://web3js.readthedocs.io/en/v1.5.2/web3.html#batchrequest
