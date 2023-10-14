import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common_widgets/file_upload_progress_dialog.dart';
import '../../../routing/app_router.dart';
import '../../../utils/exceptions.dart';
import '../../../utils/extensions.dart';
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
    implements IAppErrorHandler {
  late AppDocumentRepository<UploadDocumentsController> docRepo;
  late TripController trips;
  late DocumentsNotifier docList;
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
    docList = ref.read(documentsProvider.call(DocumentsArgs(arg.documentType, null)).notifier);
    state = UploadDocumentsState(documentType: dropDownOptions.first);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startScan();
    });
    return state;
  }

  Future<void> startScan([bool firstScan = true]) async {
    isScanning.setState(true);
    GeniusScanConfig config;
    ProviderArgsSaver.instance.uploadArgs = arg;
    switch (arg.uploadType) {
      case UploadType.camera:
        config = GeniusScanConfig.camera();
        break;
      case UploadType.gallery:
        String path = '';
        try {
          var status = await Permission.photos.status;
          if (status.isGranted || status.isDenied) {
            path = (await picker.pickImage(source: ImageSource.gallery))!.path;
          }
        } catch (e) {
          path = '';
        }
        config = GeniusScanConfig.gallery(path);
        break;
    }
    try {
      var res = await FlutterGeniusScan.scanWithConfiguration(config.toJson().removeNulls);
      var results = GeniusScanResults.fromJson(jsonDecode(jsonEncode(res)));
      if (firstScan && results.scans.isEmpty) {
        router.pop();
      }
      state = state.copyWith(
          pages: [...state.pages, ...results.scans.map<String>((e) => Scan.toPathString(e.enhancedUrl!)).toList()]);
      firstScan = false;
    } catch (e) {
      if (firstScan) {
        isScanning.setState(false);
        router.pop();
      }
      debugPrint('$e');
      state = state;
    }
    isScanning.setState(false);
  }

  void removePage() {
    if (state.pages.isEmpty) return;
    var pages = List<String>.from(state.pages);
    pages.removeAt(state.pageNumber);
    var indexToResetTo = state.pageNumber >= state.pages.length - 1 ? state.pageNumber - 1 : state.pageNumber;
    state = state.copyWith(pages: pages, pageNumber: indexToResetTo);
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
    await _doUpload(pdfFile);

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
      if (arg.documentType == DisplayDocumentType.tripDocuments) {
        ref.read(tripControllerProvider.notifier).refreshCurrentTrip(arg.tripId!);
      }
    }
  }

  Future<void> _doUpload(File pdfFile) async {
    switch (arg.documentType) {
      case DisplayDocumentType.tripDocuments:
        var trip = trips.getTrip(arg.tripId!);
        await docRepo.uploadTripDocuments(trip!.companyCode!, state.documentType!, pdfFile, arg.tripId!);
        await trips.refreshCurrentTrip(arg.tripId!);
      case DisplayDocumentType.personalDocuments:
        await docRepo.uploadPersonalDocuments(state.documentType!, pdfFile);
        await docList.getDocuments();
      case DisplayDocumentType.paystubs:
        await Future.value(null);
      case DisplayDocumentType.tripReport:
        await docRepo.uploadTripReport(userData.getCompanyOwned.companyCode!, state.documentType!, pdfFile);
        await docList.getDocuments();
    }
  }

  bool get shouldShowDeleteAndUploadButton => state.pages.isNotEmpty;

  List<UploadDocumentOptions> get dropDownOptions {
    switch (arg.documentType) {
      case DisplayDocumentType.tripDocuments:
        var trip = trips.getTrip(arg.tripId!);
        return UploadDocumentOptions.getOptionsList([
          'Unclassified',
          'Receipt',
          'BOL',
          'Proof of Delivery',
          'Load Securement',
          'Temperature Settings',
          'Seal',
          'Trailer Photo',
          'Other'
        ], trip?.companyCode);

      case DisplayDocumentType.personalDocuments:
        return UploadDocumentOptions.getOptionsList(
            ["Driver License", "Medical"], userData.getCompanyOwned.companyCode!);
      case DisplayDocumentType.paystubs:
        return [];
      case DisplayDocumentType.tripReport:
        return UploadDocumentOptions.getOptionsList(['Trip Report'], userData.getCompanyOwned.companyCode!);
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
  final String companyCode, title;

  UploadDocumentOptions({required this.companyCode, required this.title});

  static List<UploadDocumentOptions> getOptionsList(List<String> titles, String? companyCode) =>
      titles.map((e) => UploadDocumentOptions(companyCode: companyCode ?? "", title: e)).toList();
}
