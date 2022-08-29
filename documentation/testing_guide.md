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

### Run the app (Milestone 1)

Open a command line terminal, and run the following commands

Make sure that either iOS Simulator or Android Emulator are up and running, then Flutter will automatically find and attach to them. 

```
git clone git@github.com:hypha-dao/hashed-wallet.git
cd hashed-wallet
git checkout v1.0.0_M1_00 
flutter pub get
flutter run
```

## Testing the app once running

1. Import Account
On the first screen, select "Import Account"
Import an existing account on hashed network using the 12 recovery words

Please contact me for an existing account. 

2. On the bottom nav bar, tap "Settings" - the gear icon

3. Tap "Key Guardians"

4. On the "My Guardians" screen, tap the + button

5. On the "Enter Guardian Address" enter guardian addres. You can use any valid Substrate chain address here, subject only to checking by the recovery pallet itself. 

Demo accounts I was using - copy paste these:

5FyG1HpMSce9As8Uju4rEQnL24LZ8QNFDaKiu5nQtX6CY6BH
5Ca9Sdw7dxUK62FGkKXSZPr8cjNLobuGAgXu6RCM14aKtz6T
5C8126sqGbCa3m7Bsg8BFQ4arwcG81Vbbwi34EznBovrv7Zf

Note: The recovery pallet needs the guardian addresses to be sorted. The wallet will sort them automatically before sending them off to the API call. Users don't need to worry about the order the guardians are in.

6. Enter 1 or 2 more guardian addresses, as per above. When 2 ore more are selected, the "activate" button will become active

7. Click the "activate" button - guardians are now set up. 

8. Go back to the main wallet screen

9. Go back to "Settings", "Key Guardians" -> Guardians are now set up and showing

10. Remove the guardians if desired - this is not part of the delivery, but makes testing easier. 

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
