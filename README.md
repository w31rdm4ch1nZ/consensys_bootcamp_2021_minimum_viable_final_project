# My Consensys 2021 Bootcamp Final Project

This project has an overambitious goal, that eventually results in a very simplistic design of its initial purpose:
an expression of the web3, by bridging the digital content creation economy which thrives in the "NFT ecosystem", with the DeFi stack.

The result is this attempt to design a simple version of a decentralized, autonomous, generalized content creation/production protocol.

There are 3 kind of users, each with a different flow (dashboards from my frontend perspective):
- Investors, who are funding what I call a "Request for Content" (defined further);
- Content Providers, who are the entities committing to produce/create the content defined by a Request for Content (RfC);
- Any user, who should be able to acces the contents produced through the protocol.

The "Request for Content" is a tokenized set of requirements for a content creation. It is meant to allow this trustless content economy between users/investors/content-consumers and creators/content-producers.

I took inspiration of the Gnosis Conditional Token framework for the Request for Content design, although following my reasonning I deviated from it.

I have explored many ideas and technology aspects of Ethereum and web3 as I was designing this project. Most are not yet implemented - even when the implementation is relatively clearly defined. 
That is why there is currently in this repository a folder which is more an archive of this process than of any immediate utility.

## The general flow is as followed (the frontend should help to make it clear):

1. A user proposes a Request for Content, through a set of options that are presented to her. Once satisfied, she mints this set of requirements that the content provider will have to honor to claim any success and the following rewards.
2. A round starts where investors signal (or not) their interest for the RfC, by locking an amount of their choice for a minimum duration of 15 days (as for the initial proposer, to avoid some form of RfC spamming).
3. A blind reversed auction starts where entities signal their commitment to deliver the content through submitting the amount of what they suggest this content production should require, exactly as defined by the RfC. This ends with one entity being selected and the amount of the bid being locked.
4. The investors send as much Ether as they want to fund the Content Provider. Once the amount required by a Content Provider is met, the RfC is minted as an NFT. 
5. The users have access to activities on-chain that gives some information about the RfC production status, until the Content Provider present it, through the forntend (the dashboards).
6. In case of a successful delivery (which always implies some deadline), the investors get a share on payments made for future acces to the content, and the Content Provider gets rewarded with a payment.
7. In case of failure to deliver the RfC, the funds commited by the Content Provider are redistributed to the investors.
8. Any user can access the content for the price determined by the investors (for now, the mean of what they invested - very simplified obviously). In some instances, a content can be considered something which should be a *common good*, in which case the protocol treasury buys back the shares of the investors to make it accessible to anyone, in a permissionless fashion.

Many things are simplified, some not enough, and others don't represent the actual state of my idea for this protocol. I think of it as the first iteration of this idea.

## Directory structure

It follows the truffle boilerplate, except for:
- a folder for the frontend, with a subfolder including the javascript files.
- the "archive" referred to before, as I think it might be of interest for whoever would like to dig in - but mostly for me, in the future.
- The contracts are organized in a fashion that shows the future direction in integrating more DeFi existing projects, to leverage DeFi in ways that lead to the protocol autonomy, and creates incentives for the participants to the protocol in a trustless way. 

## Frontend hosted

TBD

## Certification NFT - Ethereum address

TBD


## Installing dependencies

TBD

## How to run the project

TBD

## How to run the smart contracts test units

TBD

## Link to the screencast

TBD