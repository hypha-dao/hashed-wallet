## Tutorial - How to Run

### Prerequisites

Install [Flutter](https://docs.flutter.dev/get-started/install)

There is three ways to run the app: Native on device, on iOS Simulator, or on Android Emulator.

#### 1 - Native on Phone

Provide email and I will add you to Google Play Store Testing Track, and iOS Testflight, to install the app natively through the respective app stores. 

#### 2 - MacOS
On MacOS, install [XCode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)

This will install an app called "Simluator" - run Simulator

#### 3 - Other platforms
On other platforms, [install the Android Emulator and Android Studio](https://developer.android.com/studio/run/emulator)

### Run the app

```
git clone git@github.com:hypha-dao/hashed-wallet.git
cd hashed-wallet
git checkout v1.0.0_M1_00 
flutter pub get
flutter run
```

## Build

### Build for Android

Create an app bundle and upload to Google Play

```flutter build appbundle```

### Build for iOS 

For iOS App store release, we build with XCode - but before running the XCode build, we need to run the flutter build for iOS.

1 - Build for iOS flutter
```flutter build ios```

2 - Build with XCode for App store distrubution as usual

