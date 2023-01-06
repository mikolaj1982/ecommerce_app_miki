@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app_miki/src/features/authentication/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  group('AccountScreenController', () {
    late MockAuthRepository authRepository;
    late AccountScreenController controller;

    setUp(() {
      // setup
      authRepository = MockAuthRepository();
      controller = AccountScreenController(authRepository: authRepository);
    });

    /// when we create the controller state is AsyncValue.data(null)
    test('initial state is AsyncValue.data(null)', () {
      verifyNever(authRepository.signOut);
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test(
      'signOut success',
      () async {
        /// stub... it is telling what to return when the signOut method is called
        when(authRepository.signOut).thenAnswer(
          (_) => Future.value(),
        );

        /// needs to be invoked before controller.signOut()
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            const AsyncData<void>(null),
          ]),
        );
        // run
        await controller.signOut();

        // verify
        verify(() => authRepository.signOut()).called(1);
        expect(controller.debugState, const AsyncData<void>(null));
      },
    );

    test(
      'signOut fails',
      () async {
        final exception = Exception('signOut failed');
        when(authRepository.signOut).thenThrow(exception);

        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            predicate<AsyncValue<void>>((value) {
              expect(value.hasError, true);
              return true;
            }),
          ]),
        );

        await controller.signOut();

        verify(() => authRepository.signOut()).called(1);
        expect(controller.debugState.hasError, true);
        expect(controller.debugState, isA<AsyncError>());
      },
    );
  });
}
