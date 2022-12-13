import 'dart:async';

import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/user_tenant.dart';
import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:alvys3/src/features/documents/data/data_provider.dart';
import 'package:alvys3/src/features/documents/data/repositories/trip_docs_repository_impl.dart';
import 'package:alvys3/src/features/documents/domain/document_state/document_state.dart';
import 'package:alvys3/src/features/documents/domain/trip_documents/trip_documents.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../network/api_response.dart';
import '../data/repositories/documents_repository.dart';

final tripDocsPageControllerProvider =
    AutoDisposeFutureProviderFamily<List<TripDocuments>, String>(
        (ref, tripId) async {
  final result =
      await ref.watch(tripDocsRepositoryImplProvider).getTripDocs(tripId);
  if (result.success) {
    return result.data!;
  } else {
    throw Exception(result.error!);
  }
});

class DocumentsNotifier
    extends AutoDisposeFamilyAsyncNotifier<DocumentState, DocumentType> {
  late AppDocumentsRepository docRepo;

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
        // TODO: Handle this case.
        break;
      case DocumentType.paystubs:
        //var driverUser = ref.read(authProvider).value!.driver!;
        var res = await docRepo.getPaystubs(DriverUser(
            id: '05e697bc147e45d984028d80db0db6f3',
            userTenants: [UserTenant(companyCode: "TR058")]));
        state = AsyncValue.data(state.value!.copyWith(paystubs: res.data!));
        break;
    }
  }
}

final documentsProvider = AutoDisposeAsyncNotifierProviderFamily<
    DocumentsNotifier, DocumentState, DocumentType>(DocumentsNotifier.new);
