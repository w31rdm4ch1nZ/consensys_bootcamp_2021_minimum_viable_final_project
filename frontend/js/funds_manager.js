var Web3 = require('web3');
var web3 = new Web3(Web3.givenProvider || "https://ropsten.infura.io/v3/" + INFURA_ID);

//see for integration in the homepage, accessble to all users - maybe put it in the main js script
const requiredEth = (await myContract.getEstimatedETHforDAI(daiAmount).call())[0];
const sendEth = requiredEth * 1.1;      // to force to send slightly more than the estimate to limit reverted txs

//      => https://github.com/compound-finance/compound-js
//          => See in particular: https://compound.finance/docs/compound-js#cToken
// OR use the Compound (lower-level) API: https://compound.finance/docs/api
// Also see the Consensys demo github repo: https://github.com/ajb413/consensys-academy-compound-js


const main = async () => {
const account = await Compound.api.account({
    "addresses": "0xB61C5971d9c0472befceFfbE662555B78284c307",
    "network": "ropsten"
});

let daiBorrowBalance = 0;
if (Object.isExtensible(account) && account.accounts) {
    account.accounts.forEach((acc) => {
        acc.tokens.forEach((tok) => {
            if (tok.symbol === Compound.cDAI) {
            daiBorrowBalance = +tok.borrow_balance_underlying.value;
            }
        });
    });
}

console.log('daiBorrowBalance', daiBorrowBalance);
}

main().catch(console.error);