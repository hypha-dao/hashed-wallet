# Hashed Wallet

Based on Seeds Light Wallet

## Getting Started

```
git clone [this repo]
cd hashed_wallet
flutter pub get
flutter run
```

## Dev configuration

Use the projects git hooks
```
git config core.hooksPath .githooks/
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

