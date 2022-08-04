#!/usr/bin/env node

require('dotenv').config()
const program = require('commander')

const { ApiPromise, WsProvider } = require("@polkadot/api");
const { Keyring } = require("@polkadot/keyring");
const { mnemonicGenerate } = require('@polkadot/util-crypto');

// mnemonic: someone course sketch usage whisper helmet juice oyster rebuild razor mobile announce
const acct_0 = "5FyG1HpMSce9As8Uju4rEQnL24LZ8QNFDaKiu5nQtX6CY6BH"
// mnemonic: dress teach unveil require supply move butter sort cruise divide nice account
const acct_1 = "5Ca9Sdw7dxUK62FGkKXSZPr8cjNLobuGAgXu6RCM14aKtz6T"
// mnemonic: slogan crime relief smile door make deliver staff lonely hello worry sure
const acct_2 = "5C8126sqGbCa3m7Bsg8BFQ4arwcG81Vbbwi34EznBovrv7Zf"

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
    console.error("Address incorrect: " + steve.address + " expected: " + process.env.STEVE_ADDRESS)
  }

  const balance = await getBalance(steve.address, api)

  console.log("steve balance: " + balance)

  return {
    api,
    keyring,
    steve
  }

}

const getBalance = async (address, api) => {
  const { nonce, data: balance } = await api.query.system.account(address);

  console.log(`${address}: balance of ${balance.free} and a nonce of ${nonce}`);

  return balance.free
}

const createAccounts = async (number) => {
  const { api, keyring } = await init()

  const accounts = []
  for (var i = 0; i < number; i++) {
    const mnemonic = mnemonicGenerate(12);

    console.log("adding account: " + mnemonic)

    // add the account, encrypt the stored JSON with an account-specific password
    var pair = keyring.addFromUri(mnemonic)
    pair.mnemonic = mnemonic

    //console.log(i + " pair " + JSON.stringify(pair, null, 2))

    accounts.push(pair)
  }

  // we could write accounts to a file and then use the file in the other functions
  // but for now, write down manually
  counter = 0
  for (a of accounts) {
    console.log("// mnemonic: " + a.mnemonic)
    console.log("const acct_" + (counter++) + " = '" + a.address + "'")
  }

  return accounts
}

const createRecovery = async () => {

  const { api, keyring, steve } = await init()

  const createRecovery = await api.tx.recovery.createRecovery(
    [
      acct_0,
      acct_1,
      acct_2
    ], 2, 0)
    .signAndSend(steve);

  console.log(createRecovery.toHex());

  return createRecovery.toHex()

}

const queryRecovery = async () => {

  const { api, keyring, steve } = await init()

  const recoverable = await api.query.recovery.recoverable.entries(steve.address);

  console.log("recoverable: " + JSON.stringify(recoverable, null, 2))

  return recoverable

  // console.log("process recoverable: ")
  // const recoveryMap = getActiveRecovery.map(([k, v]) => { return { key: k.toHuman(), val: v.toHuman() } })
  // console.log(recoveryMap);

  // return recoveryMap
}

const queryActiveRecovery = async () => {
  const { api, keyring, steve } = await init()

  const getActiveRecovery = await api.query.recovery.activeRecoveries.entries(steve.address);

  console.log("active recovery: " + JSON.stringify(getActiveRecovery))

  console.log("process active: ")
  console.log(getActiveRecovery.map(
    ([k, v]) => { return { key: k.toHuman(), val: v.toHuman() } })
  );

}

program
  .command('create_accounts')
  .description('create some accounts to be used as guardians - store them')
  .action(async function () {

    console.log("Create accounts...")

    const result = await createAccounts(3)

    //console.log("accounts: "+JSON.stringify(result, null, 2))
  })

program
  .command('init')
  .description('init and check balance')
  .action(async function () {

    console.log("init...")

    const result = await init()

    //console.log("result: " + JSON.stringify(result, null, 2))
  })

program
  .command('create_recovery')
  .description('create recovery')
  .action(async function () {

    console.log("Create recovery...")

    const result = await createRecovery()

    console.log("transaction ID: " + JSON.stringify(result, null, 2))
  })

program
  .command('query_recovery')
  .description('Query recovery')
  .action(async function () {

    console.log("Query recovery...")



    const result = await queryRecovery()

    console.log("result: " + JSON.stringify(result, null, 2))
  })

program
  .command('query_active')
  .description('Query recovery')
  .action(async function () {

    console.log("Query active...")

    const result = await queryActiveRecovery()

    console.log("active: " + JSON.stringify(result, null, 2))
  })

program
  .command('cancel_recovery')
  .description('Cancel recovery')
  .action(async function () {

    console.log("Cancel recovery...")

    const result = await createRecovery()

    console.log("transaction ID: " + JSON.stringify(result, null, 2))
  })


program.parse(process.argv)

var NO_COMMAND_SPECIFIED = program.args.length === 0;
if (NO_COMMAND_SPECIFIED) {
  program.help();
}
