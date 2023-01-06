import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// we can test controllers with unit tests no widget testing needed
/// since they don't contain  any UI code
class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository authRepository;

  // calling with AsyncData(null) initially, const AsyncValue.data(null) means not loading
  AccountScreenController({required this.authRepository}) : super(const AsyncData<void>(null));

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}

final accountScreenControllerProvider =
    StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepository);
});
