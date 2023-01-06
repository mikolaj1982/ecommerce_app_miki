import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/domain/app_user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = 'test123';
  final testUser = AppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
  );

  FakeAuthRepository getRepo() {
    return FakeAuthRepository(addDelay: false);
  }

  group('FakeAuthRepository', () {
    test('currentUser is null', () {
      final repo = getRepo();
      addTearDown(() => repo.dispose());
      expect(repo.currentUser, null);
      expect(repo.authStateChanges(), emits(null));
    });

    test('signInWithEmailAndPassword', () async {
      final repo = getRepo();
      addTearDown(repo.dispose);
      await repo.createUserWithEmailAndPassword(
        testEmail,
        testPassword,
      );
      await repo.signOut();
      await repo.signInWithEmailAndPassword(testEmail, testPassword);
      expect(repo.currentUser, testUser);
      expect(repo.authStateChanges(), emits(testUser));
    });

    test('currentUser is not null after registration', () async {
      final authRepository = getRepo();
      addTearDown(authRepository.dispose);
      await authRepository.createUserWithEmailAndPassword(
        testEmail,
        testPassword,
      );
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('currentUser is null after signOut', () async {
      final authRepository = getRepo();
      addTearDown(authRepository.dispose);
      await authRepository.createUserWithEmailAndPassword(
        testEmail,
        testPassword,
      );
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));

      await authRepository.signOut();
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('sign in throws when user not found', () async {
      final authRepository = getRepo();
      addTearDown(authRepository.dispose);
      await expectLater(
        () => authRepository.signInWithEmailAndPassword(
          testEmail,
          testPassword,
        ),
        throwsException,
        // throwsA(Exception('User not found')),
      );
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    /// use emitsInOrder to values in the stream
    test('sign in throws when wrong password', () async {
      final authRepository = getRepo();
      await authRepository.createUserWithEmailAndPassword(
        testEmail,
        testPassword,
      );
      await authRepository.signOut();
      await expectLater(
        () => authRepository.signInWithEmailAndPassword(
          testEmail,
          'wrong password',
        ),
        throwsException,
      );
    });
  });
}
