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
  const steve = keyring.addFromUri(
    process.env.STEVE_WORDS
  );

  if (steve.address == process.env.STEVE_ADDRESS) {
    console.log("Address correct: " + steve.address)
  } else {
    console.error("Address incorrect: "+ steve.address+ " expected: " + process.env.STEVE_ADDRESS)
  }

  // known mnemonic, well, now it is - don't use it for funds
  const mnemonic1 = 'sample split bamboo west visual approve brain fox arch impact relief smile';
  // mnemonic1 as sr25519 ==> 5FLiLdaQQiW7qm7tdZjdonfSV8HAcjLxFVcqv9WDbceTmBXA
  const pubkey1 = "5FLiLdaQQiW7qm7tdZjdonfSV8HAcjLxFVcqv9WDbceTmBXA"

  const res1 = keyring.addFromUri(
    mnemonic1
  );

  console.log("res1 "+JSON.stringify(res1, null, 2))

  if (res1.address == pubkey1) {
    console.log("res1 Address correct: " + res1.address)
  } else {
    console.error("Address incorrect: "+ res1.address+ " expected: " + pubkey1)
  }

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