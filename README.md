# Alvys Driver Companion

## Getting Started 🚀

**Clone Project**
https://alvysio@dev.azure.com/alvysio/Alvys/\_git/AlvysMobileAppV3

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
