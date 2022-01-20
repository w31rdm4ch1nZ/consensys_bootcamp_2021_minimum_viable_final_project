var eth = new web3.eth.Contract(abi,ETH);

erc20Instance.methods.approve(contractAddress, amount).send({from: userAddress}, 
function(err, transactionHash) {
    //some code
});