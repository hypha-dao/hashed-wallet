#!/usr/bin/env node

require('dotenv').config()
const program = require('commander')

const { ApiPromise, WsProvider } = require("@polkadot/api");
const { Keyring } = require("@polkadot/keyring");
const { mnemonicGenerate } = require('@polkadot/util-crypto');
const { hexToU8a, u8aToHex } = require("@polkadot/util");

// mnemonic: someone course sketch usage whisper helmet juice oyster rebuild razor mobile announce
const acct_0 = process.env.G0_ADDRESS
// mnemonic: dress teach unveil require supply move butter sort cruise divide nice account
const acct_1 = process.env.G1_ADDRESS
// mnemonic: slogan crime relief smile door make deliver staff lonely hello worry sure
const acct_2 = process.env.G2_ADDRESS

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
    console.log("added " + a.address)
  }

  return {
    api,
    keyring,
    steve
  }

}

const getBalance = async (address, api) => {
  const { nonce, data: balance } = await api.query.system.account(address);

  console.log(`${address}: balance of ${balance.free / 10E12} and a nonce of ${nonce}`);

  return balance.free / 10E12
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

// find keypair by address - may not be needed?
const findKeyring = async (address) => {
  // 5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym
  const { api, keyring, steve } = await init()

}



const createRecovery = async () => {
  try {
    const { api, keyring, steve } = await init()

    const address = process.env.STEVE_ADDRESS

    console.log("balance before create recovery")
    const balanceBefore = await getBalance(address, api);

    // Note we will pass in the address, but we can easily resolve this with keyring.getPair..
    // Alternatively we can pass in the correct keypair

    let response = await new Promise(async (resolve) => {
      const unsubscribe = await api.tx.recovery.createRecovery(
        [
          acct_0,
          acct_1,
          acct_2
        ].sort(), 2, 0)
        .signAndSend(keyring.getPair(address), ({ events = [], status, txHash }) => {
          console.log(`Current status is ${status.type} status.isInBlock: ` + status.isInBlock + " status.isFinalized: " + status.isFinalized);

          if (status.isFinalized || status.isInBlock) {
            var transactionSuccess = false

            console.log(`Transaction included at blockHash ${status.isFinalized ? status.asFinalized : status.asInBlock}`);
            console.log(`Transaction hash ${txHash.toHex()}`);

            // Loop through Vec<EventRecord> to display all events
            events.forEach(({ phase, event: { data, method, section } }) => {
              console.log(`\t' ${phase}: ${section}.${method}:: ${data}`);
              if (section == "system" && method == "ExtrinsicFailed") {
                transactionSuccess = false
              }
              if (section == "system" && method == "ExtrinsicSuccess") {
                transactionSuccess = true
              }
            });

            console.log("unsubscribing from updates..")
            unsubscribe()
            // => 
            // ' {"applyExtrinsic":1}: balances.Withdraw:: ["5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym",85795211]
            // ' {"applyExtrinsic":1}: system.ExtrinsicFailed:: [{"module":{"index":10,"error":"0x04000000"}},{"weight":148937000,"class":"Normal","paysFee":"Yes"}]

            resolve({
              events,
              status,
              txHash,
              transactionSuccess,
            })
          }
        });
    });

    const balanceAfter = await getBalance(address, api);

    const cost = balanceBefore - balanceAfter
    console.log("transaction cost: "+cost)

    //console.log("tx result " + JSON.stringify(response, null, 2))

    await api.disconnect()
    console.log("disconnecting done")
  } catch (err) {
    console.log("Create recovery error: " + err)
  }
}

const removeRecovery = async () => {

  const { api, keyring, steve } = await init()

  const address = process.env.STEVE_ADDRESS

  console.log("balance before remove recovery")
  const balanceBefore = await getBalance(address, api);

  // Note we will pass in the address, but we can easily resolve this with keyring.getPair..
  let response = await new Promise(async (resolve) => {
    const unsubscribe = await api.tx.recovery.removeRecovery()
      .signAndSend(keyring.getPair(address), ({ events = [], status, txHash }) => {
        console.log(`Remove Recovery: Current status is ${status.type}`);

        if (status.isFinalized || status.isInBlock) {
          var transactionSuccess = false

          console.log(`Transaction included at blockHash ${status.isFinalized ? status.asFinalized : status.asInBlock}`);
          console.log(`Transaction hash ${txHash.toHex()}`);

          // Loop through Vec<EventRecord> to display all events
          events.forEach(({ phase, event: { data, method, section } }) => {
            console.log(`\t' ${phase}: ${section}.${method}:: ${data}`);
            if (section == "system" && method == "ExtrinsicFailed") {
              transactionSuccess = false
            }
            if (section == "system" && method == "ExtrinsicSuccess") {
              transactionSuccess = true
            }
          });

          console.log("unsubscribing from updates..")
          unsubscribe()
          // => 
          // ' {"applyExtrinsic":1}: balances.Withdraw:: ["5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym",85795211]
          // ' {"applyExtrinsic":1}: system.ExtrinsicFailed:: [{"module":{"index":10,"error":"0x04000000"}},{"weight":148937000,"class":"Normal","paysFee":"Yes"}]

          resolve({
            events,
            status,
            txHash,
            transactionSuccess,
          })

        }
      });
  });

  //console.log("tx result " + JSON.stringify(response, null, 2))

  console.log("balance after remove recovery")
  const balanceAfter = await getBalance(address, api);

  const cost = balanceBefore - balanceAfter
  console.log("remove transaction cost: "+cost)

  await api.disconnect()
  console.log("disconnecting done")

  return response

}

const queryRecovery = async () => {

  const { api, keyring, steve } = await init()

  console.log("query for steve " + steve.address)

  const recoverable = await api.query.recovery.recoverable(steve.address);

  console.log("recoverable: " + JSON.stringify(recoverable, null, 2))

  console.log("disconnecting")

  await api.disconnect()
  console.log("disconnecting done")

  return recoverable
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

    ///
    /// Testing retrieval of keypar from keyring - it works...
    ///
    // console.log("keypair: " + JSON.stringify(result.steve, null, 2))
    // const publicKey = result.steve.publicKey
    // const keyPair = result.keyring.getPair(u8aToHex(publicKey));
    // console.log("res 2 pair "+JSON.stringify(keyPair, null, 2))

    await result.api.disconnect();
  })

program
  .command('create_recovery')
  .description('create recovery')
  .action(async function () {

    console.log("Create recovery...")

    const result = await createRecovery()
  })

program
  .command('query_recovery')
  .description('Query recovery')
  .action(async function () {

    console.log("Query recovery...")

    const result = await queryRecovery()
  })

program
  .command('query_active')
  .description('Query active')
  .action(async function () {

    console.log("Query active...")

    const result = await queryActiveRecovery()

    console.log("active: " + JSON.stringify(result, null, 2))
  })

program
  .command('remove_recovery')
  .description('Cancel recovery')
  .action(async function () {

    console.log("Remove recovery...")

    const result = await removeRecovery()

    //console.log("result: " + JSON.stringify(result, null, 2))
  })


program.parse(process.argv)

var NO_COMMAND_SPECIFIED = program.args.length === 0;
if (NO_COMMAND_SPECIFIED) {
  program.help();
}
