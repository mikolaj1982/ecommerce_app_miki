import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_form_type.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// when you extend StateNotifier, you need to provide the initial value
class SingInScreenController extends StateNotifier<SignInState> {
  final AuthRepository authRepository;

  SingInScreenController({
    required this.authRepository,
    required SignInFormType formType,
  }) : super(SignInState(formType: formType));

  Future<bool> submit({required String email, required String password}) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _authenticate(email, password));
    state = state.copyWith(value: value);
    return value.hasError == false;
  }

  Future<void> _authenticate(String email, String password) async {
    switch (state.formType) {
      case SignInFormType.signIn:
        return authRepository.signInWithEmailAndPassword(email, password);
      case SignInFormType.register:
        return authRepository.createUserWithEmailAndPassword(email, password);
    }
  }

  void updateFormType(SignInFormType type) {
    state = state.copyWith(formType: type);
  }
}

// notifier, state and parameter (that's is family)
final singInScreenControllerProvider =
    StateNotifierProvider.autoDispose.family<SingInScreenController, SignInState, SignInFormType>((
  ref,
  formType,
) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SingInScreenController(
    authRepository: authRepository,
    formType: formType,
  );
});
