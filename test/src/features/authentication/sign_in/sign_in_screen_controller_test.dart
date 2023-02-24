@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_form_type.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  ProviderContainer makeProviderContainer({
    required MockAuthRepository authRepository,
  }) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('just for clarification', () {
    final error = Exception('test');
    expect(const AsyncValue<void>.loading(), const AsyncLoading<void>());
    expect(const AsyncValue<void>.data(null), const AsyncData<void>(null));
    expect(AsyncValue<void>.error(error, StackTrace.empty), AsyncError<void>(error, StackTrace.empty));
  });

  group(
    'submit createUserWithEmailAndPassword',
    () {
      late MockAuthRepository authRepository;
      late SingInScreenController controller;

      const testEmail = 'test@test.com';
      const testPassword = 'test123';
      const testFormType = SignInFormType.register;

      setUp(() {
        authRepository = MockAuthRepository();
        final container = makeProviderContainer(authRepository: authRepository);
        controller = container.read(signInControllerProvider.notifier);
      });

      test(
        '''
      Given formType is register
      when createUserWithEmailAndPassword succeeds
      then return true
      and state is AsyncData
      ''',
        () async {
          /// code to stub signIn method
          /// Given formType is signIn
          ///  when signInWithEmailAndPassword succeeds
          when(() => authRepository.createUserWithEmailAndPassword(
                testEmail,
                testPassword,
              )).thenAnswer((_) => Future.value());

          ///  and state is AsyncData
          expectLater(
            controller.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              const AsyncData<void>(null),
            ]),
          );

          ///  then return true
          final result = await controller.submit(
            email: testEmail,
            password: testPassword,
            formType: testFormType,
          );
          expect(result, true);
        },
      );

      test(
        '''
      Given formType is register
      when createUserWithEmailAndPassword fails
      then return false
      and state is AsyncError
      ''',
        () async {
          /// Given formType is signIn
          /// when signInWithEmailAndPassword fails
          final exception = Exception('create user failed');
          when(() => authRepository.createUserWithEmailAndPassword(
                testEmail,
                testPassword,
              )).thenThrow(exception);

          /// and state is AsyncError
          expectLater(
            controller.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              predicate<AsyncValue<void>>((state) {
                expect(state.hasError, true);
                return true;
              }),
            ]),
          );

          ///  then return false
          final result = await controller.submit(
            email: testEmail,
            password: testPassword,
            formType: testFormType,
          );
          expect(result, false);
        },
      );
    },
  );
}
