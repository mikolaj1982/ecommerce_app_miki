@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_form_type.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_screen_controller.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  test('just for clarification', () {
    final error = Exception('test');
    expect(const AsyncValue<void>.loading(), const AsyncLoading<void>());
    expect(const AsyncValue<void>.data(null), const AsyncData<void>(null));
    expect(AsyncValue<void>.error(error, StackTrace.empty), AsyncError<void>(error, StackTrace.empty));
  });

  group(
    'updateFormType',
    () {
      late MockAuthRepository authRepository;
      late SingInScreenController controller;

      setUp(() {
        authRepository = MockAuthRepository();
      });

      test('updateFormType register -> signIn', () {
        controller = SingInScreenController(authRepository: authRepository, formType: SignInFormType.register);
        controller.updateFormType(SignInFormType.signIn);
        expect(
          controller.debugState,
          SignInState(
            formType: SignInFormType.signIn,
            value: const AsyncData<void>(null),
          ),
        );
      });

      test('updateFormType signIn -> register', () {
        controller = SingInScreenController(authRepository: authRepository, formType: SignInFormType.signIn);
        controller.updateFormType(SignInFormType.register);
        expect(
          controller.debugState,
          SignInState(
            formType: SignInFormType.register,
            value: const AsyncData<void>(null),
          ),
        );
      });
    },
  );

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
        controller = SingInScreenController(authRepository: authRepository, formType: testFormType);
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
              SignInState(
                formType: SignInFormType.register,
                value: const AsyncLoading<void>(),
              ),
              SignInState(
                formType: SignInFormType.register,
                value: const AsyncData<void>(null),
              ),
            ]),
          );

          ///  then return true
          final result = await controller.submit(
            email: testEmail,
            password: testPassword,
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
              SignInState(
                formType: SignInFormType.register,
                value: const AsyncLoading<void>(),
              ),
              predicate<SignInState>((state) {
                expect(state.formType, SignInFormType.register);
                expect(state.value.hasError, true);
                return true;
              }),
            ]),
          );

          ///  then return false
          final result = await controller.submit(
            email: testEmail,
            password: testPassword,
          );
          expect(result, false);
        },
      );
    },
  );

  group(
    'submit signInWithEmailAndPassword',
    () {
      late MockAuthRepository authRepository;
      late SingInScreenController controller;

      const testEmail = 'test@test.com';
      const testPassword = 'test123';
      const testFormType = SignInFormType.signIn;

      setUp(() {
        authRepository = MockAuthRepository();

        controller = SingInScreenController(authRepository: authRepository, formType: testFormType);
      });

      test(
        '''
      Given formType is signIn
      when signInWithEmailAndPassword fails
      then return false
      and state is AsyncError
      ''',
        () async {
          /// Given formType is signIn
          /// when signInWithEmailAndPassword fails
          final exception = Exception('sign in failed');
          when(() => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              )).thenThrow(exception);

          /// and state is AsyncError
          expectLater(
            controller.stream,
            emitsInOrder([
              SignInState(
                formType: SignInFormType.signIn,
                value: const AsyncLoading<void>(),
              ),
              predicate<SignInState>((state) {
                expect(state.formType, SignInFormType.signIn);
                expect(state.value.hasError, true);
                return true;
              }),
            ]),
          );

          ///  then return false
          final result = await controller.submit(
            email: testEmail,
            password: testPassword,
          );
          expect(result, false);
        },
      );

      test(
        '''
      Given formType is signIn
      when signInWithEmailAndPassword succeeds
      then return true
      and state is AsyncData
      ''',
        () async {
          /// code to stub signIn method
          /// Given formType is signIn
          //  when signInWithEmailAndPassword succeeds
          when(() => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              )).thenAnswer((_) => Future.value());

          ///  and state is AsyncData
          expectLater(
            controller.stream,
            emitsInOrder([
              SignInState(
                formType: SignInFormType.signIn,
                value: const AsyncLoading<void>(),
              ),
              SignInState(
                formType: SignInFormType.signIn,
                value: const AsyncData<void>(null),
              ),
            ]),
          );

          ///  then return true
          final result = await controller.submit(
            email: testEmail,
            password: testPassword,
          );
          expect(result, true);
        },
      );
    },
  );
}
