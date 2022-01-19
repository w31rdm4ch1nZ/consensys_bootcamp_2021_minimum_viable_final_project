## Common Attacks protection

- Whenever possible, I use a specific compiler pragma. Nevertheless, I have to take into account compatibility with the DeFi protocols whose contracts are sometimes different.
I avoid to use the very last version of the compiler, as recommended, so I use a versino relatively already battle-tested by many other projects - avoiding bugs and potential introduction of vulnerabilities.

- I use the pattern Checks-Effects-Interactions, through using require, make changes, and ending with a call to an external contract when it happens, to avoid reentrancy attacks and other manipulation of the state of my contracts in case the underlying external contracts happen to be vulnerable.

- I use the the recommended Pull Over Push, with my FundsManager contract as a proxy for the whole protocol. The users all interact only with this contract, and the crypto-currency transfers can only happen through a call from the other contract (for minting operations for example). I use the ERC1155 operator allowance pattern to facilitate this.

- For the Request for Content token, I make sure that the imput passed by the proposer of a new RfC can only pass successfully states that are already encoded in my RequestForContent.sol contract (under the enum type). Any input that is not part of the encoded possible states lead the transaction to revert without effect. 

- I use the OpenZeppelin library as a protection against reentrancy atacks and over/under-flow exploitations. It does not stop me to code without minding to introduce a reentrancy vulnerability. But it constitutes a good added safety feature.

- The use of a Role-based Access Control pattern is to avoid, among other privilege abuses and exploitations, attacks such as Tx.Origin Authentication.

## Small comment on economic attacks and mechanism design

I have always kept in mind during the design and at implementation time the vectors that are introduced by the participants possible malevolent behaviors.
Therefore, I have continuously tried to think about the ways to keep incentives aligned between the different participants, and what I could anticipate as loopholes in the incentive logic. An example of this is the silent auction for the Content Providers (so I maximize the chances for an honest estimation of the cost the CP is asking for the content production).

A lot of the simplification of the ideas I had during the design pertains to this kind of reasonning: mechanism design, and the protection of the protocol and the participants through incentives choices, and schemes that minimize the efficiency of any attempt to hurt other participants, or to make the protocol misbehave, be it for one's own gain or in a purely destructive way.

My focus on those aspects is motivated by my passion for this way of thinking, and learning more and more about it.
