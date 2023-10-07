import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/magic_strings.dart';
import '../../authentication/presentation/auth_provider_controller.dart';
import '../data/repositories/documents_repository.dart';
import '../domain/document_state/document_state.dart';

class DocumentsArgs {
  final DisplayDocumentType documentType;
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
      case DisplayDocumentType.tripDocuments:
        break;
      case DisplayDocumentType.personalDocuments:
        var res = await docRepo.getPersonalDocs(auth.driver!);
        state = AsyncValue.data(state.value!.copyWith(documentList: res));
        break;
      case DisplayDocumentType.paystubs:
        await getPaystubs();
        state = AsyncValue.data(state.value!.copyWith(canLoadMore: state.value!.documentList.length == top));

        break;
      case DisplayDocumentType.tripReport:
        var res = await docRepo.getTripReportDocs(auth.getCompanyOwned.companyCode!, auth.driver!);
        state = AsyncValue.data(state.value!.copyWith(documentList: res));
        break;
    }
  }

  Future<void> getPaystubs() async {
    if (auth.state.value!.canViewPaystubs) {
      var res = await docRepo.getPaystubs(
        auth.getCompanyOwned.companyCode!,
        auth.driver!,
        top = top,
      );
      state = AsyncValue.data(state.value!.copyWith(documentList: res));
    } else {
      state = AsyncValue.data(state.value!.copyWith(documentList: []));
    }
  }

  String get pageTitle {
    switch (arg.documentType) {
      case DisplayDocumentType.tripDocuments:
        return 'Trip Documents';
      case DisplayDocumentType.personalDocuments:
        return 'Personal Documents';
      case DisplayDocumentType.paystubs:
        return 'Paystubs';
      case DisplayDocumentType.tripReport:
        return 'Trip Reports';
    }
  }

  Future<void> loadMorePaystubs() async {
    if (arg.documentType == DisplayDocumentType.paystubs &&
        state.value!.canLoadMore &&
        auth.state.value!.canViewPaystubs) {
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
