import 'dart:async';

import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/user_tenant.dart';
import 'package:alvys3/src/features/documents/data/data_provider.dart';
import 'package:alvys3/src/features/documents/domain/document_state/document_state.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../routing/routing_arguments.dart';
import '../data/repositories/documents_repository.dart';

class DocumentsNotifier
    extends AutoDisposeFamilyAsyncNotifier<DocumentState, DocumentType> {
  late AppDocumentsRepository docRepo;
  int top = 10;

  @override
  FutureOr<DocumentState> build(DocumentType arg) async {
    docRepo = ref.watch(documentsRepositoryProvider);
    state = AsyncValue.data(DocumentState());
    await init();
    return state.value!;
  }

  Future<void> init() async {
    state = const AsyncValue.loading();
    await getDocuments();
  }

  Future<void> getDocuments() async {
    switch (arg) {
      case DocumentType.tripDocuments:
        String tripId = ref.read(tripPageControllerProvider).value!.tripId!;
        var res = await docRepo.getTripDocs(tripId);
        state =
            AsyncValue.data(state.value!.copyWith(tripDocuments: res.data!));
        break;
      case DocumentType.personalDocuments:
        var res = await docRepo.getPersonalDocs();
        state = AsyncValue.data(
            state.value!.copyWith(personalDocuments: res.data!));
        break;
      case DocumentType.paystubs:
        await getPaystubs();
        state = AsyncValue.data(state.value!
            .copyWith(canLoadMore: state.value!.paystubs.length == top));

        break;
      case DocumentType.tripReport:
        var res = await docRepo.getTripReportDocs();
        state = AsyncValue.data(state.value!.copyWith(tripReports: res.data!));
        break;
    }
  }

  Future<void> getPaystubs() async {
    var res = await docRepo.getPaystubs(
        DriverUser(
          id: '05e697bc147e45d984028d80db0db6f3',
          userTenants: [UserTenant(companyCode: "TR058")],
        ),
        top = top);
    state = AsyncValue.data(state.value!.copyWith(paystubs: res.data!));
  }

  String get pageTitle {
    switch (arg) {
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
    if (arg == DocumentType.paystubs && state.value!.canLoadMore) {
      top += 10;
      await getPaystubs();
      if (state.value!.paystubs.length < top) {
        state = AsyncValue.data(state.value!.copyWith(canLoadMore: false));
      }
    }
  }

  List<PDFViewerArguments> get documentThumbnails {
    switch (arg) {
      case DocumentType.tripDocuments:
        return state.value!.tripDocuments
            .map((doc) => PDFViewerArguments(doc.link!, doc.type!))
            .toList();
      case DocumentType.personalDocuments:
        return state.value!.personalDocuments
            .map((doc) => PDFViewerArguments(doc.link!, doc.type!))
            .toList();
      case DocumentType.paystubs:
        return state.value!.paystubs
            .map((doc) => PDFViewerArguments(
                doc.link, DateFormat.yMEd().format(doc.datePaid!)))
            .toList();
      case DocumentType.tripReport:
        return state.value!.tripReports
            .map((doc) => PDFViewerArguments(doc.link!, doc.type!))
            .toList();
    }
  }
}

final documentsProvider = AutoDisposeAsyncNotifierProviderFamily<
    DocumentsNotifier, DocumentState, DocumentType>(DocumentsNotifier.new);
