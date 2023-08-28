import 'package:alvys3/src/features/documents/domain/app_document/app_document.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
  List<AppDocument> get displayPaystubs => documentList.where((element) => element.date.isNullOrAfterNow).toList();
  factory DocumentState.fromJson(Map<String, dynamic> json) => _$DocumentStateFromJson(json);
}
