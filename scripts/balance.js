#!/usr/bin/env node

require('dotenv').config()
const { ApiPromise, WsProvider } = require("@polkadot/api");
const { Keyring } = require("@polkadot/keyring");

const init = async () => {
  // Initialize the provider to connect to the local node
  const provider = new WsProvider(process.env.NODE_ENDPOINT);

  // Create the API and wait until ready
  const api = await ApiPromise.create({ provider });

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
  const { nonce, data: balance } = await api.query.system.account(steve.address);

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