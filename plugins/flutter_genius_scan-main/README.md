# Genius Scan SDK for Flutter

## Description

This Flutter plugin allows you to access the [Genius Scan SDK](https://geniusscansdk.com) core features from a Flutter application. The plugin relies on the ScanFlow module which provides a all-in-one scanner module with simple configurable input.

  - Automatic document detection
  - Document perspective correction
  - Image enhancement with 4 different modes (Black & white, Monochrome, Color, Photo)
  - Batch scanning of several pages in row
  - OCR to extract raw text from images and generate PDF with invisible text layer

## License

This plugin is based on the Genius Scan SDK for which you need to [setup a license](#set-the-license-key).
You can aleady try the "demo" version for free by not setting a license key, the only limitation being that the app will exit after 60 seconds.

To buy a license:
1. [Sign up](https://sdk.geniusscan.com/apps) to our developer console
2. Submit a quote request for each application

You can learn more about [licensing](https://geniusscansdk.com/license/licensing) in our website and contact us at sdk@geniusscan.com for further questions.

## Getting started

Follow the install steps from https://pub.dev/packages/flutter_genius_scan/install

### Additional steps on Android

- To your app `android/app/build.gradle`, change minSdkVersion to `21`.

### Additional steps on iOS

- Add the required permission to your `Info.plist`:
```
NSCameraUsageDescription - "We use the camera for <provide a good reason why you are using the camera>"
```
- In your `Podfile`, add the following line:
```
platform :ios, '13.0'
```

## Usage

### Set the license key

Initialize the SDK with a valid license key:

```dart
FlutterGeniusScan.setLicenseKey('REPLACE_WITH_YOUR_LICENSE_KEY');
```

This method doesn't return anything. However, other methods of the plugin will fail if the license key is invalid or expired. Note that, for testing purpose, you can also use the plugin without setting a license key, but it will only work for 60 seconds.

**It is recommended to show a message to users asking them to update the application in case the license has expired.**

### Start the scanner module

```dart
var result = await FlutterGeniusScan.scanWithConfiguration(configuration);
```

See the [API doc](https://pub.dev/documentation/flutter_genius_scan/latest/flutter_genius_scan/FlutterGeniusScan/scanWithConfiguration.html) for the options supported in the `configuration` object and for the result structure.

### (Optional) Generate a PDF document from multiple pages

If you'd like to rearrange the pages returned by the ScanFlow or add some more pages, you can do so and generate a PDF document from these pages:

```dart
await FlutterGeniusScan.generateDocument(configuration)
```

See the [API doc](https://pub.dev/documentation/flutter_genius_scan/latest/flutter_genius_scan/FlutterGeniusScan/generateDocument.html) for the options supported in the `configuration` object.

# FAQ

## How do I get the UI translated to another language?

The device's locale determines the languages used by the plugin for all strings: user guidance, menus, dialogs…

The plugin supports a wide variety of languages: English (default), Arabic, Chinese (Simplified), Chinese (Traditional), Danish, Dutch, French, German, Hebrew, Indonesian, Italian, Japanese, Korean, Portuguese, Russian, Spanish, Swedish, Turkish, Vietnamese.

NB: iOS applications must be [localized in XCode by adding each language to the project](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#appendix-updating-the-ios-app-bundle).

## What should I do if my license is invalid?

Make sure that the license key is correct, that is has not expired, and that it is used with the App ID it was generated for. To learn more about the procurement and replacement of license keys, refer to the [Licensing FAQ](https://geniusscansdk.com/license/licensing).

## Troubleshooting

Refer to the troubleshooting guides of the native libraries to resolve common configuration and build problems:

- [iOS](https://geniusscansdk.com/docs/v5/ios/troubleshooting/)
- [Android](https://geniusscansdk.com/docs/v5/android/troubleshooting/)
# flutter_genius_scan
