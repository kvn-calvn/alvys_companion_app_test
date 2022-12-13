import 'package:alvys3/src/features/documents/domain/trip_documents/trip_documents.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../paystub/paystub.dart';

part 'document_state.freezed.dart';
part 'document_state.g.dart';

@freezed
class DocumentState with _$DocumentState {
  factory DocumentState({
    @Default(<Paystub>[]) List<Paystub> paystubs,
    @Default(<TripDocuments>[]) List<TripDocuments> tripDocuments,
    @Default('') String filePath,
    @Default('') String title,
  }) = _DocumentState;

  factory DocumentState.fromJson(Map<String, dynamic> json) =>
      _$DocumentStateFromJson(json);
}
