import 'dart:convert';

import 'package:alvys3/src/common_widgets/file_upload_progress_dialog.dart';
import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:alvys3/src/features/documents/domain/genius_scan_config/genius_scan_config.dart';
import 'package:alvys3/src/features/documents/domain/upload_documents_state/upload_documents_state.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../trips/presentation/controller/trip_page_controller.dart';
import '../data/data_provider.dart';
import '../data/repositories/documents_repository.dart';

class UploadDocumentsController extends AutoDisposeFamilyNotifier<
    UploadDocumentsState, UploadDocumentArgs> {
  late AppDocumentsRepository docRepo;
  late TripController trips;
  late AuthProviderNotifier userData;
  late PageController pageController;
  ImagePicker picker = ImagePicker();

  @override
  build(arg) {
    pageController = PageController();
    docRepo = ref.read(documentsRepositoryProvider);
    trips = ref.read(tripControllerProvider.notifier);
    userData = ref.read(authProvider.notifier);
    startScan();
    return UploadDocumentsState();
  }

  Future<void> startScan() async {
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
      var res = await FlutterGeniusScan.scanWithConfiguration(
          config.toJson().removeNulls);
      var results = GeniusScanResults.fromJson(jsonDecode(jsonEncode(res)));
      state = state.copyWith(pages: [
        ...state.pages,
        ...results.scans
            .map<String>((e) => Scan.toPathString(e.enhancedUrl!))
            .toList()
      ]);
    } catch (e) {
      debugPrint('$e');
      state = state;
    }
  }

  void removePage() {
    if (state.pages.isNotEmpty) return;
    var pages = state.pages;
    pages.removeAt(pageController.page!.floor());
    state = state.copyWith(pages: pages);
  }

  Future<void> uploadFile(BuildContext context, bool mounted) async {
    //generate document before sending
    showDocumentProgressDialog(context);

    if (mounted) Navigator.of(context, rootNavigator: true).pop();
  }

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
}

final uploadDocumentsController = AutoDisposeNotifierProviderFamily<
    UploadDocumentsController,
    UploadDocumentsState,
    UploadDocumentArgs>(UploadDocumentsController.new);

class UploadDocumentArgs {
  final UploadType uploadType;
  final DocumentType documentType;
  final String? tripId;
  UploadDocumentArgs(
      {this.tripId, required this.uploadType, required this.documentType});
}

class UploadDocumentOptions {
  final String companyCode, title;

  UploadDocumentOptions({required this.companyCode, required this.title});

  static List<UploadDocumentOptions> getOptionsList(
          List<String> titles, String? companyCode) =>
      titles
          .map((e) =>
              UploadDocumentOptions(companyCode: companyCode ?? "", title: e))
          .toList();
}
