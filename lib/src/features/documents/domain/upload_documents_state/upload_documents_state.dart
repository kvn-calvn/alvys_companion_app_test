import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_documents_state.freezed.dart';

@freezed
class UploadDocumentsState with _$UploadDocumentsState {
  factory UploadDocumentsState({
    @Default(<String>[]) List<String> pages,
    File? finalFile,
  }) = _UploadDocumentsState;
}
