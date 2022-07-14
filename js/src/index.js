#!/usr/bin/env node

const { ApiPromise, WsProvider } = require("@polkadot/api");
const { Keyring } = require("@polkadot/keyring");

var provider;
var api;
var keyring;

// returns a keyring entry 
const keyringAddFromUri = (wordsOrPrivateKey) => {
  return keyring.addFromUri(wordsOrPrivateKey);
}

const getBalance = async (address) => {
  const { nonce, data: balance } = await api.query.system.account(address);
  return balance
}

// init packages
const init = async ({ endpoint }) => {
  // Initialize the provider to connect to the local node
  console.log("init start.")

  provider = new WsProvider(endpoint);

  console.log("create keyring.")

  // Constuct the keyring after the API (crypto has an async init)
  keyring = new Keyring({ type: "sr25519" });

  console.log("create api.")

  // Create the API and wait until ready
  api = await ApiPromise.create({ provider });

  console.log("init done.")
}



console.log('JS core loaded. Call init({endpoint: "..."})');

const service1 = {
  keyringAddFromUri,
  getBalance,
  init,
};

window.service1 = service1;
window.api = api;
window.provider = provider;
window.keyring = keyring;

// globalThis.service.init({
//   endpoint: "wss://n1.hashed.systems"
//  })