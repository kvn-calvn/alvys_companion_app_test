import 'dart:async';
import '../../authentication/presentation/auth_provider_controller.dart';
import '../domain/document_state/document_state.dart';
import '../../../utils/magic_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/documents_repository.dart';

class DocumentsArgs {
  final DocumentType documentType;
  final String? tripId;

  DocumentsArgs(this.documentType, this.tripId);
}

class DocumentsNotifier extends AutoDisposeFamilyAsyncNotifier<DocumentState, DocumentsArgs> {
  late AppDocumentRepository docRepo;
  late AuthProviderNotifier auth;
  int top = 10;

  @override
  FutureOr<DocumentState> build(DocumentsArgs arg) async {
    docRepo = ref.watch(documentsRepositoryProvider);
    auth = ref.read(authProvider.notifier);
    state = AsyncValue.data(DocumentState());
    await init();
    return state.value!;
  }

  Future<void> init() async {
    state = const AsyncValue.loading();
    await getDocuments();
  }

  Future<void> getDocuments() async {
    switch (arg.documentType) {
      case DocumentType.tripDocuments:
        var res = await docRepo.getTripDocs(arg.tripId!);
        state = AsyncValue.data(state.value!.copyWith(documentList: res));
        break;
      case DocumentType.personalDocuments:
        var res = await docRepo.getPersonalDocs(auth.driver!);
        state = AsyncValue.data(state.value!.copyWith(documentList: res));
        break;
      case DocumentType.paystubs:
        await getPaystubs();
        state = AsyncValue.data(state.value!.copyWith(canLoadMore: state.value!.documentList.length == top));

        break;
      case DocumentType.tripReport:
        var res = await docRepo.getTripReportDocs(auth.driver!);
        state = AsyncValue.data(state.value!.copyWith(documentList: res));
        break;
    }
  }

  Future<void> getPaystubs() async {
    var res = await docRepo.getPaystubs(
      auth.driver!,
      top = top,
    );
    state = AsyncValue.data(state.value!.copyWith(documentList: res));
  }

  String get pageTitle {
    switch (arg.documentType) {
      case DocumentType.tripDocuments:
        return 'Trip Documents';
      case DocumentType.personalDocuments:
        return 'Personal Documents';
      case DocumentType.paystubs:
        return 'Paystubs';
      case DocumentType.tripReport:
        return 'Trip Reports';
    }
  }

  Future<void> loadMorePaystubs() async {
    if (arg.documentType == DocumentType.paystubs && state.value!.canLoadMore) {
      top += 10;
      await getPaystubs();
      if (state.value!.documentList.length < top) {
        state = AsyncValue.data(state.value!.copyWith(canLoadMore: false));
      }
    }
  }
}

final documentsProvider =
    AutoDisposeAsyncNotifierProviderFamily<DocumentsNotifier, DocumentState, DocumentsArgs>(DocumentsNotifier.new);
