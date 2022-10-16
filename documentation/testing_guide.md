# Testing Guide

## Running the App

To run the app, either install the binary from one of the app stores, or build the app on the local machine. 

For app stores, use Google Play store for Android devices, and Apple Testflight for iOS devices. 

To build locally, install iOS Simulator or Android emulator, install flutter, and run the app from the code in the repository - steps below. 

Demo Accounts: Please contact me via Matrix / Element so I can provide a Hashed demo account with some Hashed tokens, since setting up guardians requires a small fee, and therefore requires an account that has a balance. 

### Binaries from App Stores

#### Android
Install on Android via Google Play Store https://play.google.com/apps/internaltest/4701631300800602818

#### iOS / iPhone
Install on iOS via Apple Testflight: (waiting for app review for link - contact me via Riot/Element to add emails manually)

### Building Locally

Install [Flutter](https://docs.flutter.dev/get-started/install)

#### 1 - MacOS
1. Install [XCode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
2. Open XCode 
3. From the XCode menu, select Open Developer Tool > Simulator.


#### 2 - Other platforms
1. [install the Android Emulator and Android Studio](https://developer.android.com/studio/run/emulator)
2. [Run the Emulator](https://developer.android.com/studio/run/emulator)

### Run the app (Milestone 2)

Open a command line terminal, and run the following commands

Make sure that either iOS Simulator or Android Emulator are up and running, then Flutter will automatically find and attach to them. 

```
git clone git@github.com:hypha-dao/hashed-wallet.git
cd hashed-wallet
git checkout v1.0.0_M2 
flutter pub get
flutter run
```

## Testing the app once running

For milestone 2, we are testing recovery of an account, so we have 3 different roles played by 5 different accounts:

STEVE - the lost account 
Guardians - G0, G1, and G2, Steve's guardians (friends)
Rescuer - the account rescuing Steve's account

I am providing Steve, G0, G1, and G2, and Rescuer accounts, see Element chat. 

The tester is free to test this with other accounts also through, only needs to create a lost account, a rescuer account, and N guardian accounts. 

### Guardians Setup  (Already in milestone 1)

You can skip this step, as Steve already has guardians set up.

However, if you want to test with your own accounts, follow the guardians setup steps:

1. Import account, log in with your own account. I can send some Hashed tokens.
2. Settings
3. Key Guardians
4. Add desired addresses as guardians
5. Click "Activate"

### Recovery Setup (New in milestone 2)

1. Login as rescuer account (provided in secure chat)
2. -> Settings
3. -> Recover Account
4. -> Recovery an Account
5. Enter account address 5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym  (that's Steve)
6. Next
7. On Doalog, press "Yes"
8. On the "Recover Account" screen, click the "share" button next to the link on the top
9. Paste the link in a message and send the message to a guardian
10. Once 2 Guardians have signed, wait for the countdown timer (24 hours by default, but 5 minutes for Steve's guardian configuration)


### Vouch using shared link (New in milestone 2)

1. Login as guardian account (provided in secure chat)
2. Click on the link shared by rescuer
3. In the dialog, click "Vouch"

### Cancel malicious recovery (New in milestone 2)

1. Login as Steve
2. In the dialog, click the "Cancel Recovery" button




## Running Unit Tests

Prerequisites: 
1. Docker is [installed](https://docs.docker.com/get-docker/).
2. Docker is at version 4.11.1 (84025) or higher

_Note: Older versions of Docker fail to install Ubuntu 20.04_

```
cd docker
docker build --progress=plain -t flutterdocker .
```

Note: The docker build also runs the unit tests, and fails if the unit tests fail.

The docker build can be run repeatedly - the results are cached, but the cache is invalidated any time there's an update to the code repository so if there is new code, the tests run again. 
