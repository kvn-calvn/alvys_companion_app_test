# Alvys Driver Companion

## Prerequisites

1. MacOS (_no iOS without it_)
2. Install Flutter `brew install flutter`
Verify the installation: `flutter doctor`
3. Install [Android Studio](https://developer.android.com/studio). _Open Android Studio & Install_
    - Android SDK
    - Android SDK Command-line Tools
    - Android Virtual Device (AVD)
4. Verify Android Install: `flutter devices`
5. Install XCode: `xcode-select --install`
6. Install CocoaPods: `sudo gem install cocoapods` then `pod setup`
7. Open iOS Simulator `open -a Simulator`
8. Verify iOS Simulator `flutter doctor` ensures all iOS toolchain issues are resolved. `flutter devices`

### Android Development

Ensure that `ANDROID_HOME` is set up:

Open Preferences in Android Studio and locate the SDK path (e.g., `/Users/<username>/Library/Android/sdk`).

Add the following to your shell configuration (`~/.zshrc` or `~/.bashrc`):

```
export ANDROID_HOME=/Users/<username>/Library/Android/sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
```

Reload the shell configuration: `source ~/.zshrc`

Install the necessary build tools via Android Studio.

Go to Preferences > Appearance & Behavior > System Settings > Android SDK.

Select and install the latest API levels and SDK Tools.


## Getting Started 🚀

1. Install XCode from Mac App Store: `xcode-select --install`
2. Install Android Studio 
3. Clone Project: https://alvysio@dev.azure.com/alvysio/Alvys/\_git/AlvysMobileAppV3
4. Build & Run Project

Then run the following command:

```
$ flutter pub get && dart run build_runner build --delete-conflicting-outputs
```

_A .env file is git-ignored, you'll need to request it from a mobile developer and put in the project root._

This project contains 3 flavors:

- development
- quality assurance (qa)
- production

To run the desired flavor either use the launch configuration in the .vscode folder or use the following commands:

```sh

# Development

$ flutter run --flavor dev --target lib/dev.dart


# Quality Assurance

$ flutter run --flavor qa --target lib/qa.dart


# Production

$ flutter run --flavor prod --target lib/prod.dart

```
![](https://lh3.googleusercontent.com/pw/ADCreHfKvypHqqzN_ZplEnbEf66G81Ssl7ZPcDQGXE5mICyzUrRmA-k0R0iMrFd-vvpGFXyH69_qpYxuDTG_XB9prMU5_IFXsMGiOJ8UbBFyt6UKfuONorLNVMRLNPddTgR4FJrQm6g-nJNF4OFwKNdWkOo=w2160-h1080-s-no?authuser=0)

_\*Alvys driver companion works on iOS, Android._

---
