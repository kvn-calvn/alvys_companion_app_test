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
  List<AppDocument> displayPaystubs(bool Function(String companyCode) shouldDisplay) => documentList
      .where((element) => element.date.paystubDateShouldShow && shouldDisplay(element.companyCode))
      .toList();
  List<AppDocument> documents(DisplayDocumentType type, [bool Function(String companyCode)? shouldDisplay]) =>
      List.from(type == DisplayDocumentType.paystubs ? displayPaystubs(shouldDisplay ?? (data) => false) : documentList)
        ..sort((a, b) => a.date.isAfterNull(b.date) ? -1 : 1);
  factory DocumentState.fromJson(Map<String, dynamic> json) => _$DocumentStateFromJson(json);
}
