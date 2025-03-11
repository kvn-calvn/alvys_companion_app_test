import 'dart:async';

import 'package:flutter/services.dart';

/// The entry point for the Genius Scan SDK
class FlutterGeniusScan {
  static const MethodChannel _channel =
      const MethodChannel('flutter_genius_scan');

  /// Starts a scanning flow with 3 screens (Camera, Document Detection, Post Processing)
  ///
  /// It takes a [configuration] parameter which can take the following options:
  /// * `source`: `camera`, `image` or `library` (defaults to camera)
  /// * `sourceImageUrl`: an absolute image url, required if `source` is `image`. Example: `file:///var/…/image.png`
  /// * `multiPage`: boolean (defaults to true). If true, after a page is scanned, a prompt to scan another page will be displayed. If false, a single page will be scanned.
  /// * `multiPageFormat`: `pdf`, `tiff`, `none` (defaults to `pdf`)
  /// * `defaultFilter`: the filter that will be applied by default to enhance scans, or `none` if no enhancement should be performed by default. Default value is `automatic`.
  /// * `availableFilters`: an array of filters that the user can select when they tap on the edit filter button. Defaults to [`none`, `automatic`, `automaticMonochrome`, `automaticBlackAndWhite`, `automaticColor`, `photo`].
  /// * `pdfPageSize`: `fit`, `a4`, `letter`, defaults to fit.
  /// * `pdfMaxScanDimension`: max dimension in pixels when images are scaled before PDF generation, for example 2000 to fit both height and width within 2000px. Defaults to 0, which means no scaling is performed.
  /// * `pdfFontFileUrl`: Custom font file used during the PDF generation to embed an invisible text layer. If null, a default font is used, which only supports Latin languages.
  /// * `jpegQuality`: JPEG quality used to compress captured images. Between 0 and 100, 100 being the best quality. Default is 60.
  /// * `postProcessingActions`: an array with the desired actions to display during the post processing screen (defaults to all actions). Possible actions are `rotate`, `editFilter` and `correctDistortion`.
  /// * `defaultCurvatureCorrection`: `enabled` or `disabled` whether a curvature correction should be applied by default. Disabled by default.
  /// * `defaultScanOrientation`: `automatic` to rotate scan automatically after capture or `original` to keep original scan orientation (defaults to `automatic`).
  /// * `photoLibraryButtonHidden`: boolean specifying whether the button allowing the user to pick an image on the Camera screen should be hidden (default to false).
  /// * `flashButtonHidden`: boolean (default to false)
  /// * `defaultFlashMode`: `auto`, `on`, `off` (default to `off`)
  /// * `foregroundColor`: string representing a color, must start with a `#`. The color of the icons, text (defaults to '#ffffff').
  /// * `backgroundColor`: string representing a color, must start with a `#`. The color of the toolbar, screen background (defaults to black)
  /// * `highlightColor`: string representing a color, must start with a `#`. The color of the image overlays (default to blue)
  /// * `menuColor`: string representing a color, must start with a `#`. The color of the menus (defaults to system defaults.)
  /// * `ocrConfiguration`: text recognition options. Text recognition will run on a background thread for every captured image. No text recognition will be applied if this parameter is not present.
  ///    * `languages`: list of the BCP 47 language tags (eg `["en-US"]`) for which to run text recognition. Note that text recognition will take longer if multiple languages are specified.
  ///    * `outputFormats`: an array with the formats in which the OCR result is made available in the ScanFlow result (defaults to all formats). Possible formats are `rawText`, `hOCR` and `textLayerInPDF`.
  /// * `structuredData`: an array of the structured data you want to extract. E.g.: `['receipt', 'businessCard']`. Possible values are `receipt`, `readableCode`, `bankDetails` (iOS only), `businessCard` (iOS only).
  /// * `structuredDataReadableCodeTypes`: an array of the readable code types to extract, e.g. `['qr', 'code39']`. Possible values are `aztec`, `code39`, `code93`, `code128`, `dataMatrix`, `ean8`, `ean13`, `itf`, `pdf417`, `qr`, `upca` (Android only), `upce`, `codabar` (iOS 15+ only), `gs1DataBar` (iOS 15+ only), `microPDF417` (iOS 15+ only), `microQR` (iOS 15+ only), `msiPlessey` (iOS 15+ only).  ///
  ///
  /// The ScanFlow offers a variety of filters to enhance the appearance of different kinds of documents.
  /// Some filters are dynamic (or automatic), meaning they will apply the best enhancement possible, possibly with some constraints. For example, the `automaticBlackAndWhite` filter will apply the best enhancement, assuming that the scan is a text document and making sure the output will have a grayscale color palette.
  /// Here is a list of all possible dynamic filters: `automatic`, `automaticColor`, `automaticBlackAndWhite`, `automaticMonochrome`.
  /// Other filters are static filters, which means they always perform the same enhancement operation, without any logic on the document characteristics.
  /// The different static filters are: `photo`, `softBlackAndWhite`, `softColor`, `strongMonochrome`, `strongBlackAndWhite`, `strongColor`, `darkBackground`.
  ///
  /// It returns a `Future<Map>` containing:
  /// * `multiPageDocumentUrl`: a document containing all the scanned pages (example: "file://<filepath>.pdf")
  /// * `scans`: an array of scan objects. Each scan object has:
  ///    * `originalUrl`: The original file as scanned from the camera. "file://<filepath>.jpeg"
  ///    * `enhancedUrl`: The cropped and enhanced file, as processed by the SDK. "file://<filepath>.{jpeg|png}"
  ///    * `ocrResult`: the result of text recognition for this scan
  ///       * `text`: the raw text that was recognized
  ///       * `hocrTextLayout`: the recognized text in [hOCR](https://en.wikipedia.org/wiki/HOCR) format (with position, style…)
  ///    * `structuredData`: the result of the structured data extraction. A subdictionary will be present for each type of structured data detected by the scan flow.
  static Future<Map> scanWithConfiguration(Map configuration) async {
    return await _channel.invokeMethod('scanWithConfiguration', configuration);
  }

  /// Set the Genius Scan SDK license key with optional auto-refresh.
  ///
  /// This method doesn't return an error but will log warnings should the key be invalid or expired. All other SDK methods that return errors will report
  /// an error if there is a problem with the license key, and you must handle them to ensure you provide a good "degraded" experience.
  /// For instance, you can prompt the user to update the application to use the scanning feature in case they use a version of the application with an expired license key.
  static void setLicenseKey(String licenseKey, {bool autoRefresh = true}) {
    _channel.invokeMethod('setLicenseKey', <String, dynamic>{
        'licenseKey': licenseKey,
        'autoRefresh': autoRefresh,
      });
  }

  /// Generate a document from a list of scans
  ///
  /// It takes a [document] map with the following values:
  /// * `pages`: an array of page objects. Each page object has:
  ///    * `imageUrl`: the URL of the image file for this page, e.g. `file://<filepath>.{jpeg|png}`
  ///    * `hocrTextLayout`: the text layout in hOCR format
  ///
  /// It also takes a [configuration] parameter with the following options:
  /// * `outputFileUrl`: the URL where the document should be generated, e.g. `file://<filepath>.pdf`
  /// * `pdfFontFileUrl`: Custom font file used during the PDF generation to embed an invisible text layer. If null, a default font is used, which only supports Latin languages.
  static Future<void> generateDocument(Map document, Map configuration) async {
    await _channel.invokeMethod('generateDocument', <String, dynamic>{
        'document': document,
        'configuration': configuration,
      });
  }
}
