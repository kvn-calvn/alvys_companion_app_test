# Alvys Driver Companion

## Getting Started 🚀

**Clone Project**
https://alvysio@dev.azure.com/alvysio/Alvys/_git/AlvysMobileAppV3

Then run the following command:

```
$ flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
```

*A .env file is git-ignored, you'll need to request it from a mobile developer and put in the project root.*


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

  
![enter image description here](https://lh3.googleusercontent.com/pw/AL9nZEULT3LvStm29W8c_fLCDT4lx5Saq1Kc7a1TunU3rndrw6m-AKuqYKj1-aZzMKcjIK0CtdK0H8Nq8NKIqvaqwA8P-3G3X9_KiX0tYLigjGPxhCSBQ6OnG5HO36qDGgMVFZk0IlZhZwRcu8SXDA0oQRlTAg=w294-h636-no) 

_\*Alvys driver companion works on iOS, Android._

  

---

  
