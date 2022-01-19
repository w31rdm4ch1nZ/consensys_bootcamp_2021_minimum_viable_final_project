## Patterns in use

- I am using *inter-contracts execution* as I was from the start interested to leverage DeFi and its so-called "composability/lego" pattern.
Indeed, instead of re-implementing some of the logic in my dapp that already exists, and has been battle tested, I use Uniswap to swap Ethereum to a stablecoin (DAI for now). 
I also use contracts from Compound to put in practice one of the main goal of this project: showing an example of how to use a DeFi protocol to enable web3 protocols autonomy and sustainibility.
Knowing this, I use a public testnet where I can find instances of those projects' contracts.

Sidenote: I have chosen to systematically swap ETH to a stablecoin as I do not want the content economy to be plagued by speculation and volatility, since those do not bring any utility to this marketplace as is - it is different for some of the DeFi lego I aim to use which leverage this volatility for interetsing economic properties (Pendle - only integrated in the next iteration, no in the Final Project scope).

- I use OpenZeppelin's libraries for security purposes (protecting FundsManager.sol contract from reentrancy attacks, SafeMath and other arithmetic overflow/underflow attacks prevention), but also for a secure implementation of the ERC1155 standard interface and main contract functions.
To have my dapp interacting with the protocols mentinoed in the previous point, Uniswap and Compound, I import the useful contracts.
I use the standard interfaces of ERC1155, ERC20 and ERC721 for my protocol to be interoperable with the DeFi stack and the NFT stack as well, as my project is defined to be built on top of those stacks.

- I use an Access Control Design Pattern, ultimately a Role-based one, so I can assign different roles and avoid the super-admin pitfall.
It goes hands in hands with the purpose of having most of those roles (except for emergency roles, like the one allowing to pause a contract access) controlled by a multi-sig Gnosis wallet. At the moment you will use this dapp, the multi-sig will not yet be implemented (also for a matter of practicality in the testing aspect).

- NOT YET: I intend to systematically use the upgradable pattern, also using the OpenZeppelin library to do so. 
