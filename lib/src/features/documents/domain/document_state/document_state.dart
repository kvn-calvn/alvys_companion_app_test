import 'package:alvys3/src/features/documents/domain/personal_document/personal_document.dart';
import 'package:alvys3/src/features/documents/domain/trip_documents/trip_documents.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../paystub/paystub.dart';

part 'document_state.freezed.dart';
part 'document_state.g.dart';

@freezed
class DocumentState with _$DocumentState {
  factory DocumentState({
    @Default(<Paystub>[]) List<Paystub> paystubs,
    @Default(<TripDocuments>[]) List<TripDocuments> tripDocuments,
    @Default(<PersonalDocument>[]) List<PersonalDocument> personalDocuments,
    @Default(<PersonalDocument>[]) List<PersonalDocument> tripReports,
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
