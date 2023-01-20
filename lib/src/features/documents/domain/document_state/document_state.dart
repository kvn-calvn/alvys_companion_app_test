import 'package:alvys3/src/features/documents/domain/app_documents/app_documents.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../paystub/paystub.dart';

part 'document_state.freezed.dart';
part 'document_state.g.dart';

@freezed
class DocumentState with _$DocumentState {
  factory DocumentState({
    @Default(<Paystub>[]) List<Paystub> paystubs,
    @Default(<AppDocuments>[]) List<AppDocuments> documentList,
    @Default(false) bool canLoadMore,
    @Default('') String filePath,
    @Default('') String title,
  }) = _DocumentState;
  DocumentState._();
  List<Paystub> get displayPaystubs =>
      paystubs.where((element) => element.datePaid.isNullOrAfterNow).toList();
  factory DocumentState.fromJson(Map<String, dynamic> json) =>
      _$DocumentStateFromJson(json);
}
