import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/extensions.dart';
import '../../../../utils/magic_strings.dart';
import '../app_document/app_document.dart';

part 'document_state.freezed.dart';
part 'document_state.g.dart';

@freezed
class DocumentState with _$DocumentState {
  factory DocumentState({
    @Default(<AppDocument>[]) List<AppDocument> documentList,
    @Default(false) bool canLoadMore,
    @Default('') String filePath,
    @Default('') String title,
  }) = _DocumentState;
  DocumentState._();
  List<AppDocument> displayPaystubs(bool shouldDisplay) =>
      shouldDisplay ? documentList.where((element) => element.date.isNullOrAfterNow).toList() : [];
  List<AppDocument> documents(DisplayDocumentType type, [bool shouldDisplay = true]) =>
      type == DisplayDocumentType.paystubs ? displayPaystubs(shouldDisplay) : documentList;
  factory DocumentState.fromJson(Map<String, dynamic> json) => _$DocumentStateFromJson(json);
}
