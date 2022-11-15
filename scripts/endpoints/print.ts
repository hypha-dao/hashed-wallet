// Copyright 2017-2022 @polkadot/apps-config authors & contributors
// SPDX-License-Identifier: Apache-2.0

import { prodChains, prodRelayKusama, prodRelayPolkadot } from './production';
import { testChains, testRelayRococo, testRelayWestend } from './testing';

// export { CUSTOM_ENDPOINT_KEY } from './development';
export * from './production';
export * from './testing';

export function printWsEndpoints () {
  var chains = [
    {
        header: "Polkadot",
        isRelayChain: true,
        chain: prodRelayPolkadot,
    },
    {
        header: "Kusama",
        isRelayChain: true,
        chain: prodRelayKusama,
    },
    {
        header: "Rococo Test Chain",
        isRelayChain: true,
        chain: testRelayRococo,
    },{
        header: "Westend Test Chain",
        isRelayChain: true,
        chain: testRelayWestend,
    },    
    {
        header: "Prod Chains",
        isRelayChain: false,
        list: prodChains
    },
    {   
        text: "Test Chains",
        isRelayChain: false,
        list: testChains
    },
  ]
  console.log(JSON.stringify(chains, null, 2));
}

console.log("Here's how to auotmate this")
console.log("Put this file in its own repo, git submodule with the polkadot repo")
console.log("alter imports to point to the right things")

console.log("run like so:")
console.log("ts-node --esm --experimental-specifier-resolution=node src/endpoints/print.ts")

printWsEndpoints();
