## Endpoints

We update endpoints from the Github repository for Polkadot wallet

### Sourcing the data
This contains an explanation of this entire section of the Polkadot apps
It also contains all data we need to switch chains. 

https://github.com/polkadot-js/apps/tree/master/packages/apps-config

Production Chains
Polkadot
https://github.com/polkadot-js/apps/blob/master/packages/apps-config/src/endpoints/productionRelayPolkadot.ts

Kusama
https://github.com/polkadot-js/apps/blob/master/packages/apps-config/src/endpoints/productionRelayKusama.ts

### Processing data

clone the repository
```
mkdir tmp && cd tmp
git clone https://github.com/polkadot-js/apps
```

Copy print.ts to endpoints like so (take note of the exact path):

```
cp ../../print.ts apps/packages/apps-config/src/endpoints/print.ts
```

Run print.ts using ts-node with the following command

```
cd apps/packages/apps-config
ts-node --esm --experimental-specifier-resolution=node src/endpoints/print.ts
```

### Automating this

We can put this in its own repostory, and add git submodules of the polkadot/apps repostitory, and automate this process.

Unfortunately the format for parachains is this messy. 

There is no official format or endpoint we can call to get the whole list

This may change eventually. 

### Loading images

Images are indexed by name and in this folder - load from github directly if possible

https://github.com/polkadot-js/apps/tree/master/packages/apps-config/src/ui/logos/chains

example for the 'coinversations' chain:

Some of them are png, some are svg - some may be jpg. 

https://raw.githubusercontent.com/polkadot-js/apps/master/packages/apps-config/src/ui/logos/chains/coinversation.png