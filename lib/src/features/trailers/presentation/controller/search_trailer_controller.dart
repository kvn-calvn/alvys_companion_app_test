import 'dart:async';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';

import '../../../../network/posthog/domain/posthog_objects.dart';
import '../../../../utils/magic_strings.dart';
import '../../data/trailer_repository.dart';
import '../../domain/search_trailer_state/search_trailer_state.dart';
import '../../domain/trailer_request/trailer_request.dart';
import '../../../../network/posthog/posthog_provider.dart';
import '../../../../network/posthog/posthog_service.dart';
import '../../../../utils/exceptions.dart';
import '../../../../utils/provider_args_saver.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_trailer_controller.g.dart';

@riverpod
class SearchTrailerController extends _$SearchTrailerController implements IErrorHandler {
  late TrailerRepository repo;
  late PostHogService postHog;
  Timer? _debounceTimer;
  @override
  FutureOr<SearchTrailerState> build(SetTrailerDto dto) {
    repo = ref.read(tripTrailerRepositoryProvider);
    postHog = ref.read(postHogProvider);
    ProviderArgsSaver.instance.assignTrailerDto = dto;
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return SearchTrailerState();
  }

  Future<void> searchTrailer(String text) async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      state = const AsyncLoading();
      var trailers = await repo.getSuggestTrailers(dto.companyCode, text);
      state = AsyncData(SearchTrailerState(trailers: trailers, init: false));
    });
  }

  void clearTrailers() {
    state = AsyncData(state.value!.copyWith(trailers: []));
  }

  Future<void> setTrailer(
      BuildContext context, String text, FutureOr<void> Function(SetTrailerDto trailer) callback) async {
    var trailerId = state.value!.getTrailerId(text);
    if (trailerId == null) return;
    state = const AsyncLoading();

    await repo.assigntrailer(dto.companyCode, AssignTrailerDto(tripId: dto.tripId, trailerId: trailerId));
    state = AsyncData(state.value!);
    var updatedDto = dto.copyWith(trailerNumber: text, trailerId: trailerId);
    postHog.postHogTrackEvent(
      PosthogTag.trailerAssignment.toSnakeCase,
      {...PostHogTrailerLog.fromSetTrailerDto(dto).toJson()},
    );
    await callback(updatedDto);
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  void onError(Object exception) {
    state = AsyncData(state.value ?? SearchTrailerState());
  }

  @override
  FutureOr<void> refreshPage(String page) {}
}
