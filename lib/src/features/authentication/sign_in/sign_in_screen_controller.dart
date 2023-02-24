import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_form_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// when you extend StateNotifier, you need to provide the initial value
class SingInScreenController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  SingInScreenController({
    required this.ref,
  }) : super(const AsyncValue.data(null));

  Future<bool> submit({required String email, required String password, required SignInFormType formType}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authenticate(email, password, formType));
    return state.hasError == false;
  }

  Future<void> _authenticate(String email, String password, SignInFormType formType) async {
    final authRepository = ref.read(authRepositoryProvider);
    switch (formType) {
      case SignInFormType.signIn:
        return authRepository.signInWithEmailAndPassword(email, password);
      case SignInFormType.register:
        return authRepository.createUserWithEmailAndPassword(email, password);
    }
  }
}

final signInControllerProvider = StateNotifierProvider.autoDispose<SingInScreenController, AsyncValue<void>>((ref) {
  return SingInScreenController(ref: ref);
});
