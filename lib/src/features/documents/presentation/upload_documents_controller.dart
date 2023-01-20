import 'dart:convert';

import 'package:alvys3/src/common_widgets/file_upload_progress_dialog.dart';
import 'package:alvys3/src/features/documents/domain/genius_scan_config/genius_scan_config.dart';
import 'package:alvys3/src/features/documents/domain/upload_documents_state/upload_documents_state.dart';
import 'package:alvys3/src/features/documents/presentation/trip_docs_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/data_provider.dart';
import '../data/repositories/documents_repository.dart';

class UploadDocumentsController extends AutoDisposeFamilyNotifier<
    UploadDocumentsState, UploadDocumentArgs> {
  late AppDocumentsRepository docRepo;
  ImagePicker picker = ImagePicker();
  @override
  build(arg) {
    docRepo = ref.watch(documentsRepositoryProvider);

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
      var res = await FlutterGeniusScan.scanWithConfiguration(config.toJson());
      var results = GeniusScanResults.fromJson(jsonDecode(jsonEncode(res)));
      state = state.copyWith(pages: [
        ...state.pages,
        ...results.scans
            .map<String>((e) => Scan.toPathString(e.enhancedUrl!))
            .toList()
      ]);
    } catch (e) {
      state = state;
    }
  }

  void removePage(int index) {
    if (state.pages.isNotEmpty) return;
    var pages = state.pages;
    pages.removeAt(index);
    state = state.copyWith(pages: pages);
  }

  Future<void> uploadFile(BuildContext context, bool mounted) async {
    showDocumentProgressDialog(context);
    await docRepo.progressTest();
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
  }
}

final uploadDocumentsController = AutoDisposeNotifierProviderFamily<
    UploadDocumentsController,
    UploadDocumentsState,
    UploadDocumentArgs>(UploadDocumentsController.new);

class UploadDocumentArgs {
  final UploadType uploadType;
  final DocumentType documentType;

  UploadDocumentArgs({required this.uploadType, required this.documentType});
}
