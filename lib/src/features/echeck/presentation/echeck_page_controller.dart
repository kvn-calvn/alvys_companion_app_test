import 'package:alvys3/src/features/echeck/data/data_provider.dart';
import 'package:alvys3/src/features/echeck/data/repositories/echeck_repository_impl.dart';
import 'package:alvys3/src/features/echeck/domain/echeck_list/echeck_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EcheckPageController extends StateNotifier<AsyncValue<EcheckList?>> {
  EcheckPageController(this._echeckRepositoryImpl)
      : super(const AsyncValue.data(null));
  final EcheckRepositoryImpl _echeckRepositoryImpl;

  void getEcheckList(String tripId) async {
    state = const AsyncValue.loading();
    final result = await _echeckRepositoryImpl.getEchecksByTripId(tripId);
    if (result.success) {
      state = AsyncValue.data(result.data!);
      var test = result.data!.data!.map((e) =>
          _echeckRepositoryImpl.queryExpressNumber(e.expressCheckNumber!));
      print(test);
    } else {
      state = AsyncValue.error(result.error!);
    }
  }
/*
  void queryExpressNumber(String expressNumber) async {
    state = const AsyncValue.loading();
    final result =
        await _echeckRepositoryImpl.queryExpressNumber(expressNumber);
    if (result.success) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error!);
    }
  }*/
}

final echeckPageControllerProvider =
    StateNotifierProvider<EcheckPageController, AsyncValue<EcheckList?>>((ref) {
  return EcheckPageController(ref.watch(echeckRepositoryImplProvider));
});
