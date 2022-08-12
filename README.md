# Hashed Wallet

Polkadot Wallet With Social Recovery

by Hypha Hashed Partners

## Getting Started

### Prerequisites

Install [Flutter](https://docs.flutter.dev/get-started/install)

#### MacOS
On MacOS, install [XCode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)

This will install an app called "Simluator" - run Simulator

#### Other platforms
On other platforms, [install the Android Emulator and Android Studio](https://developer.android.com/studio/run/emulator)

### Run the app (Milestone 1)

```
git clone git@github.com:hypha-dao/hashed-wallet.git
cd hashed-wallet
git checkout v1.0.0_M1_00 
flutter pub get
flutter run
```

## Testing with docker

Prerequisites: Docker is [installed](https://docs.docker.com/get-docker/).

```
cd docker
docker build -t flutterdocker .
```

Note: The docker build also runs the unit tests, and fails if the unit tests fail.

The docker build can be run repeatedly - the results are cached, but the cache is invalidated any time there's an update to the code repository so if there is new code, the tests run again. 

## Build

### Build for Android

Create an app bundle and upload to Google Play

```flutter build appbundle```

### Build for iOS 

For iOS App store release, we build with XCode - but before running the XCode build, we need to run the flutter build for iOS.

1 - Build for iOS flutter
```flutter build ios```

2 - Build with XCode for App store distrubution as usual

