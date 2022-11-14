#!/usr/bin/env node

require('dotenv').config()
const program = require('commander')

const { ApiPromise, WsProvider } = require("@polkadot/api");
const { Keyring } = require("@polkadot/keyring");
const { mnemonicGenerate } = require('@polkadot/util-crypto');
const { hexToU8a, u8aToHex } = require("@polkadot/util");

const acct_0 = process.env.G0_ADDRESS
const acct_1 = process.env.G1_ADDRESS
const acct_2 = process.env.G2_ADDRESS
const rescuer = process.env.RESCUER_ADDRESS

const otherAccounts = [
  process.env.RESCUER_WORDS,
  process.env.G0_WORDS,
  process.env.G1_WORDS,
  process.env.G2_WORDS,
]

const init = async () => {
  // Initialize the provider to connect to the local node
  const provider = new WsProvider(process.env.NODE_ENDPOINT);
  // const provider = new WsProvider("wss://md5.network");
  //wss://n1.hashed.systems

  // Create the API and wait until ready
  const api = await ApiPromise.create({ provider });

  // Constuct the keyring after the API (crypto has an async init)
  const keyring = new Keyring({ type: "sr25519" });

  // Add steve to keyring, using secret words
  const steve = keyring.addFromUri(
    process.env.STEVE_WORDS
  );
  // Add alice to keyring, debug account
  const alice = keyring.addFromUri(
    "//ALICE"
  );

  if (steve.address == process.env.STEVE_ADDRESS) {
    console.log("Address correct: " + steve.address)
  } else {
    console.error("Address incorrect: " + steve.address + " expected: " + process.env.STEVE_ADDRESS)
  }

  for (acct of otherAccounts) {
    const a = keyring.addFromUri(
      acct
    );
    // console.log("added " + a.address)
  }

  return {
    api,
    keyring,
    steve
  }

}

const getMetadata = async () => {

  const {api} = await init();

  const metaData = await api.rpc.state.getMetadata();

  console.log("metadata: \n");
  console.log(JSON.stringify(metaData, null, 2))
  
  return metaData
}


program
  .command('run')
  .description('get meta data')
  .action(async function () {

    console.log("Getting metadata...")

    const result = await getMetadata()

  })
  
program.parse(process.argv)

var NO_COMMAND_SPECIFIED = program.args.length === 0;
if (NO_COMMAND_SPECIFIED) {
  program.help();
}
