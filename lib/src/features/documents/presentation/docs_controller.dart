import 'dart:async';

import 'upload_documents_controller.dart';
import '../../../utils/exceptions.dart';
import '../../../utils/provider_args_saver.dart';
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

class DocumentsNotifier extends AutoDisposeFamilyAsyncNotifier<DocumentState, DocumentsArgs> implements IErrorHandler {
  late AppDocumentRepository<DocumentsNotifier, UploadDocumentsController> docRepo;
  late AuthProviderNotifier auth;
  int top = 10;

  @override
  FutureOr<DocumentState> build(DocumentsArgs arg) async {
    docRepo = ref.read(documentsRepositoryProvider);
    auth = ref.read(authProvider.notifier);
    ProviderArgsSaver.instance.documentArgs = arg;
    //  state = AsyncValue.data(DocumentState());
    state = const AsyncValue.loading();
    await getDocuments();
    return state.hasValue ? state.value! : DocumentState();
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
        var res = await docRepo.getPersonalDocs(auth.tenantCompanyCodes.first, auth.driver!);
        state = AsyncData(state.hasValue ? state.value!.copyWith(documentList: res) : DocumentState(documentList: res));
        break;
      case DisplayDocumentType.paystubs:
        await getPaystubs();
        state = AsyncData(state.value!.copyWith(canLoadMore: state.value!.documentList.length == top));

        break;
      case DisplayDocumentType.tripReport:
        var res = await docRepo.getTripReportDocs(auth.getCompanyOwned.companyCode!, auth.driver!);
        state = AsyncData(state.hasValue ? state.value!.copyWith(documentList: res) : DocumentState(documentList: res));
        break;
    }
  }

  Future<void> getPaystubs() async {
    if (auth.state.value!.canViewPaystubsAll) {
      var res = await docRepo.getPaystubs(
        auth.driver!,
        top = top,
      );
      state =
          AsyncValue.data(state.hasValue ? state.value!.copyWith(documentList: res) : DocumentState(documentList: res));
    } else {
      state = AsyncValue.data(state.hasValue ? state.value!.copyWith(documentList: []) : DocumentState());
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
        auth.state.value!.canViewPaystubsAll) {
      top += 10;
      await getPaystubs();
      if (state.value!.documentList.length < top) {
        state = AsyncValue.data(state.value!.copyWith(canLoadMore: false));
      }
    }
  }

  @override
  FutureOr<void> onError(Exception ex) {
    state = !state.hasValue ? AsyncValue.data(DocumentState()) : AsyncData(state.value!);
  }

  @override
  FutureOr<void> refreshPage(String page) {}
}

final documentsProvider =
    AutoDisposeAsyncNotifierProviderFamily<DocumentsNotifier, DocumentState, DocumentsArgs>(DocumentsNotifier.new);
