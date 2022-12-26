#!/usr/bin/env node

require('dotenv').config()
const { ApiPromise, WsProvider } = require("@polkadot/api");
const { Keyring } = require("@polkadot/keyring");

const getLastBlock = async (api) => {
  const block = await api.rpc.chain.getBlock();

  console.log("block "+JSON.stringify(block, null, 2))
  console.log("last block num "+block.block.header.number)


}

const init = async () => {
  // Initialize the provider to connect to the local node
  // const provider = new WsProvider("wss://n1.hashed.systems");
  const provider = new WsProvider("wss://acala-rpc-0.aca-api.network");
  
  // Create the API and wait until ready
  const api = await ApiPromise.create({ provider });

  const chain = await api.rpc.system.chain();

  console.log(JSON.stringify(chain, null, 2))

  //await getLastBlock(api)

  const properties = await api.rpc.system.properties();
  console.log("properties: "+JSON.stringify(properties, null, 2))

  // const metaData =  api.runtimeMetadata
  // console.log("metadata: "+JSON.stringify(metaData, null, 2))

  // Constuct the keyring after the API (crypto has an async init)
  const keyring = new Keyring({ type: "sr25519" });

  // Add steve to keyring, using secret words
  steve = keyring.addFromUri(
    process.env.STEVE_WORDS
  );

  if (steve.address == process.env.STEVE_ADDRESS) {
    console.log("Address correct: " + steve.address)
  } else {
    console.error("Address incorrect: "+ steve.address+ " expected: " + process.env.STEVE_ADDRESS)
  }

  // query balance
  const systemAccount = await api.query.system.account(steve.address);
  console.log("account "+JSON.stringify(systemAccount, null, 2))

  // query assets 
  var ix = 0
  const symarr = JSON.parse(JSON.stringify(properties.tokenSymbol));

  console.log("tokens: "+symarr + " "+symarr.length)
  // for (var ix=0; ix < symarr.length; ix++) {
  //   const asset = await api.query.assets.account(ix, steve.address);
  //   console.log("asset "+symarr[ix]+" "+JSON.stringify(asset, null, 2))

  // }

  const balances = await api.query.balances.account(steve.address)
  console.log("balances "+JSON.stringify(balances, null, 2))


  const { nonce, data: balance } = systemAccount

  // Retrieve the last timestamp
  const now = await api.query.timestamp.now();

  console.log(`steve balance ${now}: balance of ${balance.free} and a nonce of ${nonce}`);

  process.exit()

//   return {
//     api, 
//     keyring,
//     steve,
//     alice
//   }
  /* Insert the extrinsics and queries here. don't run more than 1 extrinsic per script execution*/

}


 init()