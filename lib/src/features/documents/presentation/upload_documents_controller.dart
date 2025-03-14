import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../network/firebase_remote_config_service.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../common_widgets/file_upload_progress_dialog.dart';
import '../../../network/http_client.dart';
import '../../../network/posthog/domain/posthog_objects.dart';
import '../../../network/posthog/posthog_provider.dart';
import '../../../routing/app_router.dart';
import '../../../utils/exceptions.dart';
import '../../../utils/magic_strings.dart';
import '../../../utils/provider_args_saver.dart';
import '../../authentication/presentation/auth_provider_controller.dart';
import '../../trips/presentation/controller/trip_page_controller.dart';
import '../data/repositories/documents_repository.dart';
import '../domain/genius_scan_config/genius_scan_config.dart';
import '../domain/genius_scan_config/genius_scan_generate_document_config.dart';
import '../domain/upload_documents_state/upload_documents_state.dart';
import 'docs_controller.dart';

class UploadDocumentsController extends AutoDisposeFamilyNotifier<UploadDocumentsState, UploadDocumentArgs>
    implements IErrorHandler {
  late AppDocumentRepository<DocumentsNotifier, UploadDocumentsController> docRepo;
  late TripController trips;
  late DocumentsNotifier docList;
  late FirebaseRemoteConfigService remoteConfigService;
  late ScanningNotifier isScanning;
  late AuthProviderNotifier userData;
  ImagePicker picker = ImagePicker();
  late GoRouter router;

  @override
  UploadDocumentsState build(UploadDocumentArgs arg) {
    docRepo = ref.read(documentsRepositoryProvider);
    trips = ref.read(tripControllerProvider.notifier);
    userData = ref.read(authProvider.notifier);
    isScanning = ref.read(scanningProvider.notifier);
    router = ref.read(getRouter);
    remoteConfigService = ref.read(firebaseRemoteConfigServiceProvider);
    docList = ref.read(documentsProvider.call(DocumentsArgs(arg.documentType, null)).notifier);
    state = UploadDocumentsState(documentType: dropDownOptions.first);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startScan();
    });
    return state;
  }

  Future<void> startScan([bool firstScan = true]) async {
    isScanning.setState(true);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: [SystemUiOverlay.top]);
    GeniusScanConfig config;
    ProviderArgsSaver.instance.uploadArgs = arg;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: [SystemUiOverlay.top]);
    switch (arg.uploadType) {
      case UploadType.camera:
        config = GeniusScanConfig.camera();
        break;
      case UploadType.gallery:
        String? image;
        try {
          var gallaryRes = await ImagePicker().pickImage(source: ImageSource.gallery);
          image = gallaryRes?.path;
        } catch (_) {}
        config = GeniusScanConfig.gallery(image);
        break;
    }
    try {
      var res = await FlutterGeniusScan.scanWithConfiguration(config.toJson());
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
      var results = GeniusScanResults.fromJson(jsonDecode(jsonEncode(res)));
      if (firstScan && results.scans.isEmpty) {
        router.pop();
      }
      await imagePostProcessing(results.scans);
      state = state
          .copyWith(pages: [...state.pages, ...results.scans.map<String>((e) => Scan.toPathString(e.enhancedUrl!))]);
      firstScan = false;
    } catch (e) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
      if (firstScan) {
        isScanning.setState(false);
        router.pop();
      }
      debugPrint('$e');
      state = state;
    }
    isScanning.setState(false);
  }

  Future<void> imagePostProcessing(List string) async {
    var files = string.map((e) => File(Scan.toPathString(e.enhancedUrl!)));
    await files.mapAsync((x) async {
      var quality = clampDouble((remoteConfigService.pdsPageSize / await x.sizeInKb), 0.3, 1);
      var res = await FlutterImageCompress.compressWithFile(x.path, quality: (quality * 100).toInt());
      await x.writeAsBytes(res!.toList(), mode: FileMode.write);
    });
  }

  void removePage() {
    if (state.pages.isEmpty) return;
    var pages = List<String>.from(state.pages);
    pages.removeAt(state.pageNumber);
    var indexToResetTo = state.pageNumber >= state.pages.length - 1 ? state.pageNumber - 1 : state.pageNumber;
    state = state.copyWith(pages: pages, pageNumber: indexToResetTo.clamp(0, pages.length + 1));
  }

  void updatePageNumber(int index) {
    state = state.copyWith(pageNumber: index);
  }

  void updateDocumentType(UploadDocumentOptions doc) {
    state = state.copyWith(documentType: doc);
  }

  Future<void> uploadFile(BuildContext context) async {
    //generate document before sending
    showDocumentProgressDialog(context);
    var path = '${(await getTemporaryDirectory()).path}/scan.pdf';

    await FlutterGeniusScan.generateDocument(
        GeniusScanGeneratePDFConfig(
                pages: state.pages.map((e) => GeneratePDFPage(imageUrl: GeneratePDFPage.toPathString(e))).toList())
            .toJson(),
        {'outputFileUrl': GeneratePDFPage.toPathString(path)});
    var pdfFile = File(path);
    debugPrint("UPLOAD_DOC_CALLED");

    ref.read(httpClientProvider).telemetryClient.trackEvent(name: "file_properties", additionalProperties: {
      "file_size": '${await pdfFile.sizeInMb} Mb',
      "file_type": '${state.documentType?.title}'
    });

    await FirebaseAnalytics.instance.logEvent(
        name: "file_properties",
        parameters: {"file_size": '${await pdfFile.sizeInMb} Mb', "file_type": '${state.documentType?.title}'});

    // int fileLimit = 12;
    // ValidationContract.requiresWithCallback(
    //     await pdfFile.sizeInMb <= fileLimit,
    //     'File Limit Exceeded',
    //     'File is over ${fileLimit}mb. Remove some pages if possible and try again',
    //     () {
    //   onError(Exception());
    // });
    await _doUpload(pdfFile);

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      context.pop();
      if (arg.documentType == DisplayDocumentType.tripDocuments) {
        ref.read(tripControllerProvider.notifier).refreshCurrentTrip(arg.tripId!);
      }
    }
  }

  void setShowHud(bool show) => state = state.copyWith(showHud: show);

  Future<void> _doUpload(File pdfFile) async {
    final postHogService = ref.read(postHogProvider);
    var event = PosthogDocumentUploadLog(
        fileSize: '${await pdfFile.sizeInMb} Mb', documentType: '${state.documentType?.title}');
    switch (arg.documentType) {
      case DisplayDocumentType.tripDocuments:
        var trip = trips.getTrip(arg.tripId!);
        await docRepo.uploadTripDocuments(userData.driver!, state.documentType!, pdfFile, trip!);
        event = event.copyWith(tripNumber: trip.tripNumber!, tenant: trip.companyCode!, tripId: trip.id!);
        await trips.refreshCurrentTrip(arg.tripId!);
        break;
      case DisplayDocumentType.personalDocuments:
        await docRepo.uploadPersonalDocuments(userData.getCompanyOwned.companyCode!, state.documentType!, pdfFile);
        await docList.getDocuments();
        break;
      case DisplayDocumentType.paystubs:
        await Future.value(null);
        break;
      case DisplayDocumentType.tripReport:
        await docRepo.uploadTripReport(userData.getCompanyOwned.companyCode!, state.documentType!, pdfFile);
        await docList.getDocuments();
        break;
    }
    postHogService.postHogTrackEvent(PosthogTag.userUploadedDocument.toSnakeCase, {...event.toJson()});
  }

  bool get shouldShowDeleteAndUploadButton => state.pages.isNotEmpty;

  List<UploadDocumentOptions> get dropDownOptions {
    switch (arg.documentType) {
      case DisplayDocumentType.tripDocuments:
        var trip = trips.getTrip(arg.tripId!);
        return UploadDocumentOptions.getOptionsList([
          (title: 'Unclassified', data: 'Unclassified'),
          (title: 'Receipt', data: 'Receipt'),
          (title: 'Scale Ticket', data: 'Scale Ticket'),
          (title: 'Bill of Lading', data: 'Bill of Lading'),
          (title: 'Proof of Delivery', data: 'Proof of Delivery'),
          (title: 'Load Securement', data: 'Load Securement'),
          (title: 'Temperature Settings', data: 'Temperature Settings'),
          (title: 'Seal', data: 'Seal'),
          (title: 'Trailer Photo', data: 'Trailer Photo'),
          (title: 'Other', data: 'Other')
        ], trip?.companyCode);

      case DisplayDocumentType.personalDocuments:
        return UploadDocumentOptions.getOptionsList(
            [(title: "Driver License", data: "Driver License"), (title: "Medical", data: "Medical")],
            userData.getCompanyOwned.companyCode!);
      case DisplayDocumentType.paystubs:
        return [];
      case DisplayDocumentType.tripReport:
        return UploadDocumentOptions.getOptionsList(
            [(title: 'Trip Report', data: 'Trip Report')], userData.getCompanyOwned.companyCode!);
    }
  }

  @override
  FutureOr<void> onError(Exception ex) {
    if (router.routerDelegate.navigatorKey.currentContext?.mounted ?? false) {
      Navigator.of(router.routerDelegate.navigatorKey.currentContext!, rootNavigator: true).pop();
    }
  }

  @override
  FutureOr<void> refreshPage(String page) {}
}

final uploadDocumentsController =
    AutoDisposeNotifierProviderFamily<UploadDocumentsController, UploadDocumentsState, UploadDocumentArgs>(
        UploadDocumentsController.new);

final scanningProvider = NotifierProvider<ScanningNotifier, bool>(ScanningNotifier.new);

class ScanningNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setState(bool state) => this.state = state;
}

class UploadDocumentArgs {
  final UploadType uploadType;
  final DisplayDocumentType documentType;
  final String? tripId;
  UploadDocumentArgs({this.tripId, required this.uploadType, required this.documentType});
}

class UploadDocumentOptions {
  final String companyCode, title, value;

  UploadDocumentOptions({required this.companyCode, required this.title, required this.value});

  static List<UploadDocumentOptions> getOptionsList(List<({String title, String data})> titles, String? companyCode) =>
      titles.map((e) => UploadDocumentOptions(companyCode: companyCode ?? "", title: e.title, value: e.data)).toList();
}
