import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../../common_widgets/file_upload_progress_dialog.dart';
import '../../authentication/presentation/auth_provider_controller.dart';
import '../domain/genius_scan_config/genius_scan_config.dart';
import '../domain/genius_scan_config/genius_scan_generate_document_config.dart';
import '../domain/upload_documents_state/upload_documents_state.dart';
import '../../../utils/exceptions.dart';
import '../../../utils/extensions.dart';
import '../../../utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../trips/presentation/controller/trip_page_controller.dart';
import '../data/repositories/documents_repository.dart';

class UploadDocumentsController extends AutoDisposeFamilyNotifier<UploadDocumentsState, UploadDocumentArgs>
    implements IAppErrorHandler {
  late AppDocumentRepository<UploadDocumentsController> docRepo;
  late TripController trips;
  late ScanningNotifier isScanning;
  late AuthProviderNotifier userData;
  ImagePicker picker = ImagePicker();

  @override
  UploadDocumentsState build(UploadDocumentArgs arg) {
    docRepo = ref.read(documentsRepositoryProvider);
    trips = ref.read(tripControllerProvider.notifier);
    userData = ref.read(authProvider.notifier);
    isScanning = ref.read(scanningProvider.notifier);
    state = UploadDocumentsState(documentType: dropDownOptions.first);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startScan();
    });
    return state;
  }

  Future<void> startScan([bool firstScan = true]) async {
    isScanning.setState(true);
    GeniusScanConfig config;
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
      var ctx = arg.context;
      if (firstScan && results.scans.isEmpty && ctx.mounted) {
        ctx.pop();
      }
      state = state.copyWith(
          pages: [...state.pages, ...results.scans.map<String>((e) => Scan.toPathString(e.enhancedUrl!)).toList()]);
      firstScan = false;
    } catch (e) {
      var ctx = arg.context;
      if (firstScan && ctx.mounted) {
        ctx.pop();
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

  Future<void> uploadFile() async {
    //generate document before sending
    showDocumentProgressDialog(arg.context);
    var path = '${(await getTemporaryDirectory()).path}/scan.pdf';

    await FlutterGeniusScan.generateDocument(
        GeniusScanGeneratePDFConfig(
                pages: state.pages.map((e) => GeneratePDFPage(imageUrl: GeneratePDFPage.toPathString(e))).toList())
            .toJson(),
        {'outputFileUrl': GeneratePDFPage.toPathString(path)});
    var pdfFile = File(path);
    await docRepo.uploadDocuments(state.documentType?.companyCode ?? '', arg.tripId ?? '', [pdfFile]);
    var ctx = arg.context;
    if (ctx.mounted) {
      Navigator.of(ctx, rootNavigator: true).pop();
    }
  }

  bool get shouldShowDeleteAndUploadButton => state.pages.isNotEmpty;

  List<UploadDocumentOptions> get dropDownOptions {
    switch (arg.documentType) {
      case DocumentType.tripDocuments:
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

      case DocumentType.personalDocuments:
        return UploadDocumentOptions.getOptionsList(["titles"], null);
      case DocumentType.paystubs:
        return [];
      case DocumentType.tripReport:
        return [];
    }
  }

  @override
  FutureOr<void> onError() {
    var ctx = arg.context;
    if (ctx.mounted) {
      Navigator.of(ctx, rootNavigator: true).pop();
    }
  }
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
  final DocumentType documentType;
  final String? tripId;
  final BuildContext context;
  UploadDocumentArgs({this.tripId, required this.uploadType, required this.documentType, required this.context});
}

class UploadDocumentOptions {
  final String companyCode, title;

  UploadDocumentOptions({required this.companyCode, required this.title});

  static List<UploadDocumentOptions> getOptionsList(List<String> titles, String? companyCode) =>
      titles.map((e) => UploadDocumentOptions(companyCode: companyCode ?? "", title: e)).toList();
}
