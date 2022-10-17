### In depth testing

Testing is pretty complex since a user must create a recovery configuration, then another user must recover that user's account, and guardians need to sign the recovery. 

In order to make this easier, I provide a node.js script *recovery.js* which has a lost account (STEVE), a rescuer (RESCUER) and 3 guardians (G0, G1, G2)

Private keys for these will be supplied over secure channels - they are in the .env file. 

### Installation
cd scripts
npm install

### .env setup
rename file .env.example to .env and fill in the secrets and addresses


### Runtime commands

    node recovery.js create_recovery

=> Steve creates a new recovery config with G0, G1, G2 as his guardians. 

    node recovery.js query_recovery

=> query steves recovery config

    node recovery.js query_active

=> query active recoveries
    
    node recovery.js query_proxy

=> query proxies

    node recovery.js remove_recovery

=> remove steve's config

    node recovery.js initiate_recovery

=> start an active recovery on steve's account

    node recovery.js vouch_recovery 0
    node recovery.js vouch_recovery 1
    node recovery.js vouch_recovery 2

=> vouch for the active recovery on steve's account using a guardian (0..2)

    node recovery.js claim_recovery

=> rescuer claims recovery that's been vouched for by 2 guardians

    node recovery.js recover_funds

=> rescuer recovers steve's funds

    node recovery.js close_recovery
    node recovery.js close_recovery_final

=> close an active recovery from steves account / from rescuer account (final)

    node recovery.js remove_recovery_final

=> remove steve's recovery config using the rescuer account


### Example Usage

- App: Go to app, import key for rescuer, log in as rescuer
- Script: create a recovery for steve using the script
- App: In the app, rescuer create a new recovery using steve's public key
- Script: Vouch for the recovery with 2 different guardians
- App: Refresh screen, recover account (time delay is set to 0 so can instantly recover with no delay)
- App: Make calls with rescuer on behalf of Steve, close recovery and proxy
- App: Send some tokens back to Steve from rescuer so we can do it again (Steve account needs a balance to create recovery)