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
    // console.log("added " + a.address)
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
    console.log("transaction cost: " + cost)

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
            //console.log(`\t' ${phase}: ${section}.${method}:: ${data}`);
            if (section == "system" && method == "ExtrinsicFailed") {
              transactionSuccess = false
            }
            if (section == "system" && method == "ExtrinsicSuccess") {
              transactionSuccess = true
            }
          });

          console.log("unsubscribing from updates..")
          unsubscribe()

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
  console.log("remove transaction cost: " + cost)

  await api.disconnect()
  console.log("disconnecting done")

  return response

}

const initiateRecovery = async ({rescuer, lostAccount}) => {

  const { api, keyring, steve } = await init()

  console.log("init recovery: recover " + lostAccount + " from new account " + rescuer)

  const address = rescuer

  console.log("balance before initiateRecovery")
  const balanceBefore = await getBalance(address, api);

  // Note we will pass in the address, but we can easily resolve this with keyring.getPair..
  let response = await new Promise(async (resolve) => {
    const unsubscribe = await api.tx.recovery.initiateRecovery(lostAccount)
      .signAndSend(keyring.getPair(address), ({ events = [], status, txHash }) => {
        console.log(`Initiate Recovery: Current status is ${status.type}`);

        if (status.isFinalized || status.isInBlock) {
          var transactionSuccess = false

          console.log(`Transaction included at blockHash ${status.isFinalized ? status.asFinalized : status.asInBlock}`);
          console.log(`Transaction hash ${txHash.toHex()}`);

          // Loop through Vec<EventRecord> to display all events
          events.forEach(({ phase, event: { data, method, section } }) => {
            //console.log(`\t' ${phase}: ${section}.${method}:: ${data}`);
            if (section == "system" && method == "ExtrinsicFailed") {
              transactionSuccess = false
            }
            if (section == "system" && method == "ExtrinsicSuccess") {
              transactionSuccess = true
            }
          });

          console.log("unsubscribing from updates..")
          unsubscribe()

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

  console.log("balance after initiate recovery")
  const balanceAfter = await getBalance(address, api);

  const cost = balanceBefore - balanceAfter
  console.log("initiate transaction cost: " + cost)

  await api.disconnect()
  console.log("disconnecting done")

  return response

}

const vouchRecovery = async ({ guardian, rescuer, lostAccount }) => {

  const { api, keyring, steve } = await init()

  console.log(guardian + " vouch recovery: recover " + lostAccount + " from new account " + rescuer)

  const address = guardian

  console.log("balance before vouch")
  const balanceBefore = await getBalance(address, api);

  // Note we will pass in the address, but we can easily resolve this with keyring.getPair..
  let response = await new Promise(async (resolve) => {
    const unsubscribe = await api.tx.recovery.vouchRecovery(lostAccount, rescuer)
      .signAndSend(keyring.getPair(address), ({ events = [], status, txHash }) => {
        console.log(`Initiate Recovery: Current status is ${status.type}`);

        if (status.isFinalized || status.isInBlock) {
          var transactionSuccess = false

          console.log(`Transaction included at blockHash ${status.isFinalized ? status.asFinalized : status.asInBlock}`);
          console.log(`Transaction hash ${txHash.toHex()}`);

          // Loop through Vec<EventRecord> to display all events
          events.forEach(({ phase, event: { data, method, section } }) => {
            //console.log(`\t' ${phase}: ${section}.${method}:: ${data}`);
            if (section == "system" && method == "ExtrinsicFailed") {
              transactionSuccess = false
            }
            if (section == "system" && method == "ExtrinsicSuccess") {
              transactionSuccess = true
            }
          });

          console.log("unsubscribing from updates..")
          unsubscribe()

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

  console.log("balance after vouch")
  const balanceAfter = await getBalance(address, api);

  const cost = balanceBefore - balanceAfter
  console.log("vouch transaction cost: " + cost)

  await api.disconnect()
  console.log("disconnecting done")

  return response

}

/// This closes a recovery in process
/// this is called by the account defending against a malicious recovery attempt
/// This is making the call directly. 
const closeRecoveryDirect = async ({ rescuer }) => {

  const { api, keyring, steve } = await init()

  console.log(" close recovery by new account " + rescuer)

  const address = steve.address

  console.log("balance before close")
  const balanceBefore = await getBalance(address, api);

  let response = await new Promise(async (resolve) => {
    const unsubscribe = await api.tx.recovery.closeRecovery(rescuer)
      .signAndSend(keyring.getPair(address), ({ events = [], status, txHash }) => {
        console.log(`Close Recovery: Current status is ${status.type}`);

        if (status.isFinalized || status.isInBlock) {
          var transactionSuccess = false

          console.log(`Transaction included at blockHash ${status.isFinalized ? status.asFinalized : status.asInBlock}`);
          console.log(`Transaction hash ${txHash.toHex()}`);

          // Loop through Vec<EventRecord> to display all events
          events.forEach(({ phase, event: { data, method, section } }) => {
            //console.log(`\t' ${phase}: ${section}.${method}:: ${data}`);
            if (section == "system" && method == "ExtrinsicFailed") {
              transactionSuccess = false
            }
            if (section == "system" && method == "ExtrinsicSuccess") {
              transactionSuccess = true
            }
          });

          console.log("unsubscribing from updates..")
          unsubscribe()

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

  console.log("balance after close")
  const balanceAfter = await getBalance(address, api);

  const cost = balanceBefore - balanceAfter
  console.log("close transaction cost: " + cost)

  await api.disconnect()
  console.log("disconnecting done")

  return response

}

/// This closes a recovery in process
/// this is called by the rescuer after claiming the recovery successfully
/// This is making the call on behalf of the original account. 
const closeRecoveryFinalize = async ({ rescuer, lostAccount }) => {

  const { api, keyring, steve } = await init()

  console.log(" close recovery by new account " + rescuer)

  const address = rescuer

  console.log("balance before close")
  const balanceBefore = await getBalance(address, api);

  // Note we will pass in the address, but we can easily resolve this with keyring.getPair..
  let response = await new Promise(async (resolve) => {
    const unsubscribe = await api.tx.recovery
      .asRecovered(
        lostAccount,
        api.tx.recovery.closeRecovery(rescuer)
      )
      .signAndSend(keyring.getPair(address), ({ events = [], status, txHash }) => {
        console.log(`Close Recovery: Current status is ${status.type}`);

        if (status.isFinalized || status.isInBlock) {
          var transactionSuccess = false

          console.log(`Transaction included at blockHash ${status.isFinalized ? status.asFinalized : status.asInBlock}`);
          console.log(`Transaction hash ${txHash.toHex()}`);

          // Loop through Vec<EventRecord> to display all events
          events.forEach(({ phase, event: { data, method, section } }) => {
            //console.log(`\t' ${phase}: ${section}.${method}:: ${data}`);
            if (section == "system" && method == "ExtrinsicFailed") {
              transactionSuccess = false
            }
            if (section == "system" && method == "ExtrinsicSuccess") {
              transactionSuccess = true
            }
          });

          console.log("unsubscribing from updates..")
          unsubscribe()

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

  console.log("balance after close")
  const balanceAfter = await getBalance(address, api);

  const cost = balanceBefore - balanceAfter
  console.log("close transaction cost: " + cost)

  await api.disconnect()
  console.log("disconnecting done")

  return response

}

const claimRecovery = async ({ rescuer, lostAccount }) => {

  const { api, keyring, steve } = await init()

  console.log("claim recovery by new account " + rescuer)

  const address = rescuer

  console.log("balance before claim")
  const balanceBefore = await getBalance(address, api);

  // Note we will pass in the address, but we can easily resolve this with keyring.getPair..
  let response = await new Promise(async (resolve) => {
    const unsubscribe = await api.tx.recovery.claimRecovery(lostAccount)
      .signAndSend(keyring.getPair(address), ({ events = [], status, txHash }) => {
        console.log(`Claim Recovery: Current status is ${status.type}`);

        if (status.isFinalized || status.isInBlock) {
          var transactionSuccess = false

          console.log(`Transaction included at blockHash ${status.isFinalized ? status.asFinalized : status.asInBlock}`);
          console.log(`Transaction hash ${txHash.toHex()}`);

          // Loop through Vec<EventRecord> to display all events
          events.forEach(({ phase, event: { data, method, section } }) => {
            //console.log(`\t' ${phase}: ${section}.${method}:: ${data}`);
            if (section == "system" && method == "ExtrinsicFailed") {
              transactionSuccess = false
            }
            if (section == "system" && method == "ExtrinsicSuccess") {
              transactionSuccess = true
            }
          });

          console.log("unsubscribing from updates..")
          unsubscribe()

          resolve({
            events,
            status,
            txHash,
            transactionSuccess,
          })

        }
      });
  });

  console.log("balance after claim")
  const balanceAfter = await getBalance(address, api);

  const cost = balanceBefore - balanceAfter
  console.log("claim transaction cost: " + cost)

  await api.disconnect()

  return response

}

const recoverFunds = async ({ rescuer, lostAccount }) => {

  const { api, keyring, steve } = await init()

  console.log("recoverFunds by new account " + rescuer)

  const address = rescuer

  console.log("balance before recover")
  const balanceBefore = await getBalance(address, api);

  // Note we will pass in the address, but we can easily resolve this with keyring.getPair..
  let response = await new Promise(async (resolve) => {
    const unsubscribe = await api.tx.recovery
      .asRecovered(
        lostAccount,
        api.tx.balances.transferAll(address, false)
      )
      .signAndSend(keyring.getPair(address), ({ events = [], status, txHash }) => {
        console.log(`Recover Funds: Current status is ${status.type}`);

        if (status.isFinalized || status.isInBlock) {
          var transactionSuccess = false

          console.log(`Transaction included at blockHash ${status.isFinalized ? status.asFinalized : status.asInBlock}`);
          console.log(`Transaction hash ${txHash.toHex()}`);

          // Loop through Vec<EventRecord> to display all events
          events.forEach(({ phase, event: { data, method, section } }) => {
            //console.log(`\t' ${phase}: ${section}.${method}:: ${data}`);
            if (section == "system" && method == "ExtrinsicFailed") {
              transactionSuccess = false
            }
            if (section == "system" && method == "ExtrinsicSuccess") {
              transactionSuccess = true
            }
          });

          console.log("unsubscribing from updates..")
          unsubscribe()

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

  console.log("balance after recover")
  const balanceAfter = await getBalance(address, api);

  const cost = balanceBefore - balanceAfter
  console.log("recovered: " + cost)

  await api.disconnect()
  console.log("disconnecting done")

  return response

}

const removeRecoveryFinalize = async ({ rescuer, lostAccount }) => {

  const { api, keyring } = await init()

  console.log(" remove recovery finalize recovery by new account " + rescuer)

  const address = rescuer

  console.log("balance before remove")
  const balanceBefore = await getBalance(address, api);

  // Note we will pass in the address, but we can easily resolve this with keyring.getPair..
  let response = await new Promise(async (resolve) => {
    const unsubscribe = await api.tx.recovery
      .asRecovered(
        lostAccount,
        api.tx.recovery.removeRecovery()
      )
      .signAndSend(keyring.getPair(address), ({ events = [], status, txHash }) => {
        console.log(`Close Recovery: Current status is ${status.type}`);

        if (status.isFinalized || status.isInBlock) {
          var transactionSuccess = false

          console.log(`Transaction included at blockHash ${status.isFinalized ? status.asFinalized : status.asInBlock}`);
          console.log(`Transaction hash ${txHash.toHex()}`);

          // Loop through Vec<EventRecord> to display all events
          events.forEach(({ phase, event: { data, method, section } }) => {
            //console.log(`\t' ${phase}: ${section}.${method}:: ${data}`);
            if (section == "system" && method == "ExtrinsicFailed") {
              transactionSuccess = false
            }
            if (section == "system" && method == "ExtrinsicSuccess") {
              transactionSuccess = true
            }
          });

          console.log("unsubscribing from updates..")
          unsubscribe()

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

  console.log("balance after remove")
  const balanceAfter = await getBalance(address, api);

  const cost = balanceBefore - balanceAfter
  console.log("remove transaction cost: " + cost)

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
  // const getActiveRecovery = await api.query.recovery.activeRecoveries.entries("5GEbpz29EkSM3vKtzuUEXtwpK8vguYm2TRRsmekQufYJDJpz");
  
  console.log("active recovery: " + JSON.stringify(getActiveRecovery, null, 2))

  console.log("process active: ")


  // the object is an array of an array of key, value
  console.log(getActiveRecovery.map(
    ([k, v]) => { return { key: k.toHuman(), val: v.toHuman() } })
  );

  const recoveryObjects = getActiveRecovery.map(
    ([k, v]) => { 
      return { 
        key: k.toHuman(), 
        lostAccount: k.toHuman()[0],
        rescuer: k.toHuman()[1],
        data: v.toJSON() 
      } })

  for (obj of recoveryObjects) {
    console.log("recovery found: ")
    const rescuerAccount = obj.key.filter((e) => e != steve.address)[0]
    console.log("rescuer account: " + rescuerAccount)
    console.log("num signatures: " + obj.data.friends.length)
    if (obj.data.friends.length > 0) {
      console.log("signers: "+JSON.stringify(obj.data.friends, null, 2))
    }
  }

  await api.disconnect()
  console.log("disconnecting done")

  return recoveryObjects

}

const queryProxy = async (api, address) => {


  // 1 - proxy with param - not working
  // const res = await api.query.recovery.proxy("5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym");
  // proxy (acct) = reutrns null
  //  const res = await api.query.recovery.proxy("5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym");

  // 2 - entries - works
  const res = await api.query.recovery.proxy.entries();
  /// This works - returns a list of lists....
  //  list item: 
  //  [
  //   "0xa2ce73642c549ae79c14f0a671cf45f91809d78346727a0ef58c0fa03bafa3230697dc9f959072a6635d0446506c2ed242f841cafd4619614da635c66ac418d399a780839f51f9a80c779a550b8baf54",
  //   "5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym"
  // ]

  // 3 - entries with field - returns empty list, which indicates it's searching for something
  //  const res = await api.query.recovery.proxy.entries("5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym");
  // proxy res: []


  // 4 - entries with key - returns empty list
  // const res = await api.query.recovery.proxy.entries("0xa2ce73642c549ae79c14f0a671cf45f91809d78346727a0ef58c0fa03bafa3230697dc9f959072a6635d0446506c2ed242f841cafd4619614da635c66ac418d399a780839f51f9a80c779a550b8baf54");
  // proxy res: []

  // 5 - entries with key of rescuer
  // const res = await api.query.recovery.proxy("5DDEc9t4iZYb4aQ7Gqzxvda6MkRQDQM3WDPJeK1bb5h8LFVb");
  // proxy res: "5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym"

  console.log("proxy res: " + JSON.stringify(res, null, 2))



  await api.disconnect()
  console.log("disconnecting done")

  return res

}

const queryActiveRecoveryByRescuer = async (lostAccount, rescuer) => {
  const { api, keyring, steve } = await init()

  // on create recovery
  // this means we need to save the fact we are trying to rescue the lost address
  // then we need to query if the recovery already exists
  // then if it does not exist we can create it

  const getActiveRecovery = await api.query.recovery.activeRecoveries(lostAccount, rescuer);
  // const getActiveRecovery = await api.query.recovery.activeRecoveries(rescuer);

  console.log("rescuer act recovery: " + JSON.stringify(getActiveRecovery, null, 2))

  // rescuer act recovery: {
  //   "created": 1035220,
  //   "deposit": 16666666500,
  //   "friends": []
  // }
  // the object is an array of an array of key, value
  await api.disconnect()
  console.log("disconnecting done")

  return getActiveRecovery.toHuman()

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
  .command('query_proxy')
  .description('Query proxy')
  .action(async function () {

    console.log("Query proxy...")
    const { api, keyring, steve } = await init()

    const result = await queryProxy(api, steve.address)
  })

program
  .command('query_active')
  .description('Query active')
  .action(async function () {

    console.log("Query active...")

    const result = await queryActiveRecovery()

    console.log("active: " + JSON.stringify(result, null, 2))

    // console.log("queryActiveRecoveryByRescuer...")
    // const rescuerRes = await queryActiveRecoveryByRescuer(steve.address, "5G6XUFXZsdUYdB84eEjvPP33tFF1DjbSg7MPsNAx3mVDnxaW")
    // console.log("data by tuple: " + JSON.stringify(rescuerRes, null, 2))


    /// QUERY ACTIVE RESULT with no signers
    // active recovery: [["0xa2ce73642c549ae79c14f0a671cf45f9dff9094d7baf1e2d9b2e3a4253b096f86c7090fd2359d471e63883edb4a6a0cdebfac75f34f14f34d3cbffc154ae4c7f28ea266addddf8501493c613e8bdafc0b25475e47c779546c9b6ab58e0bdbdc2245503284a8dfe4c324e6dc285c88a1d",{"created":898726,"deposit":16666666500,"friends":[]}]]
    // process active: 
    // [
    //   {
    //     key: [
    //       '5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym',
    //       '5G6XUFXZsdUYdB84eEjvPP33tFF1DjbSg7MPsNAx3mVDnxaW'
    //     ],
    //     val: { created: '898,726', deposit: '16,666,666,500', friends: [] }
    //   }
    // ]
    // active: undefined


    /// After 1 friend vouched
    /// note the key is an array of 2 keys- it seems - and the value is a string that's a json object?!
    /// toHuman() converts values...

    // active recovery: [
    //   [
    //     "0xa2ce73642c549ae79c14f0a671cf45f9dff9094d7baf1e2d9b2e3a4253b096f86c7090fd2359d471e63883edb4a6a0cdebfac75f34f14f34d3cbffc154ae4c7f28ea266addddf8501493c613e8bdafc0b25475e47c779546c9b6ab58e0bdbdc2245503284a8dfe4c324e6dc285c88a1d",
    //     {
    //       "created": 898726,
    //       "deposit": 16666666500,
    //       "friends": [
    //         "5GEbpz29EkSM3vKtzuUEXtwpK8vguYm2TRRsmekQufYJDJpz"
    //       ]
    //     }
    //   ]
    // ]
    // process active: 
    // [
    //   {
    //     key: [
    //       '5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym',
    //       '5G6XUFXZsdUYdB84eEjvPP33tFF1DjbSg7MPsNAx3mVDnxaW'
    //     ],
    //     val: { created: '898,726', deposit: '16,666,666,500', friends: [Array] }
    //   }
    // ]

    /// And the recovery object needs to be looked up separately to find
    /// theshold etc

    // query for steve 5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym
    // recoverable: {
    //   "delayPeriod": 0,
    //   "deposit": 21666666450,
    //   "friends": [
    //     "5Da6BeYLC3BRvS2H3bQ6JWgMGZtqKGdaoKMPhdtYMf56VaCU",
    //     "5EUqh98iKNwWQjpzYQPVw3LEQiiaVMaB4Yp2ugXA5fMKFDLk",
    //     "5GEbpz29EkSM3vKtzuUEXtwpK8vguYm2TRRsmekQufYJDJpz"
    //   ],
    //   "threshold": 2
    // }



  })

program
  .command('remove_recovery')
  .description('remove recovery')
  .action(async function () {

    console.log("Remove recovery...")

    const result = await removeRecovery()

    //console.log("result: " + JSON.stringify(result, null, 2))
  })

program
  .command('initiate_recovery')
  .description('initiate recovery')
  .action(async function () {

    const rescuer = process.env.RESCUER_ADDRESS
    const lostAccount = process.env.STEVE_ADDRESS

    console.log("Initiate recovery of " + lostAccount + " from new account " + rescuer)

    const result = await initiateRecovery({ rescuer, lostAccount})
  })

program
  .command('vouch_recovery <n>')
  .description('vouch recovery')
  .action(async function (n) {

    const guardians = [
      process.env.G0_ADDRESS,
      process.env.G1_ADDRESS,
      process.env.G2_ADDRESS,
    ]

    const guardian = guardians[n]
    const rescuer = process.env.RESCUER_ADDRESS

    // debug code below
    //const rescuer  = "5DDEc9t4iZYb4aQ7Gqzxvda6MkRQDQM3WDPJeK1bb5h8LFVb"
    
    const lostAccount = process.env.STEVE_ADDRESS

    console.log("vouch recovery of " + lostAccount + " with account " + n + " => " + guardian)

    const result = await vouchRecovery({ guardian, rescuer, lostAccount })

  })

  program
  .command('claim_recovery')
  .description('Claim an active recovery')
  .action(async function () {
    console.log("Claim active recovery")

    const rescuer = process.env.RESCUER_ADDRESS
    const lostAccount = process.env.STEVE_ADDRESS

    console.log("Claim recovery of " + lostAccount + " from new account " + rescuer)

    const result = await claimRecovery({rescuer, lostAccount})
  })

  program
  .command('recover_funds')
  .description('Recover all funds')
  .action(async function () {
    console.log("Recover funds")

    const rescuer = process.env.RESCUER_ADDRESS
    const lostAccount = process.env.STEVE_ADDRESS

    console.log("Claim recovery of " + lostAccount + " from new account " + rescuer)

    const result = await recoverFunds({rescuer, lostAccount})
  })

program
  .command('close_recovery')
  .description('Close an active recovery - direct by owner account')
  .action(async function () {

    console.log("Close active recovery direct by owner account")

    const rescuer = process.env.RESCUER_ADDRESS

    console.log("close recovery of " + rescuer)

    const result = await closeRecoveryDirect({ rescuer })

  })

  program
  .command('close_recovery_final')
  .description('Close an active recovery with the rescuer account')
  .action(async function () {
    console.log("Close active recovery with the rescuer account")

    const rescuer = process.env.RESCUER_ADDRESS
    const lostAccount = process.env.STEVE_ADDRESS

    console.log("Close recovery of " + lostAccount + " from new account " + rescuer)

    const result = await closeRecoveryFinalize({rescuer, lostAccount})
  })

  program
  .command('remove_recovery_final')
  .description('Remove a recovery config using the rescuer account')
  .action(async function () {
    console.log("Remove a recovery config with rescuer account")

    const rescuer = process.env.RESCUER_ADDRESS
    const lostAccount = process.env.STEVE_ADDRESS

    console.log("Remove recovery")

    const result = await removeRecoveryFinalize({rescuer, lostAccount})
  })

program.parse(process.argv)

var NO_COMMAND_SPECIFIED = program.args.length === 0;
if (NO_COMMAND_SPECIFIED) {
  program.help();
}
