import 'package:ecommerce_app_miki/src/features/authentication/domain/app_user_model.dart';
import 'package:ecommerce_app_miki/src/features/authentication/domain/fake_app_user.dart';
import 'package:ecommerce_app_miki/src/utils/delay.dart';
import 'package:ecommerce_app_miki/src/utils/in_memory_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  // dispose the in-memory store when the provider is disposed
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authSateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

class FakeAuthRepository implements AuthRepository {
  final bool addDelay;

  FakeAuthRepository({this.addDelay = true});

  final _authState = InMemoryStore<AppUser?>(null);

  // List to keep track of all the users accounts
  final List<FakeAppUser?> _users = [];

  @override
  AppUser? get currentUser => _authState.value;

  @override
  Stream<AppUser?> authStateChanges() {
    return _authState.stream;
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);
    final user = _users.firstWhere((user) => user?.email == email, orElse: () => null);

    if (user == null) {
      throw Exception('User not found');
    }
    if (user.password != password) {
      throw Exception('Wrong password');
    }

    debugPrint('user found : $user');
    _authState.value = user;
  }

  void _createNewUser(String email, String password) {
    final user = FakeAppUser(
      uid: const Uuid().v1(),
      email: email,
      password: password,
    );

    // register it
    _users.add(user);

    // update the auth state
    _authState.value = user;
    debugPrint('User created: $user, number of users: ${_users.length}');
  }

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);
    _createNewUser(email, password);
  }

  @override
  Future<void> signOut() async {
    await delay(addDelay);
    _authState.value = null;
  }

  void dispose() {
    debugPrint('disposing auth repository');
    _authState.close();
  }
}

final authRepositoryProviderBasedOnEnv = Provider<AuthRepository>((ref) {
  const isFake = String.fromEnvironment('useFakeRepository') == 'true';
  return isFake ? FakeAuthRepository() : FirebaseAuthRepository();
});

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  Future<void> signInWithEmailAndPassword(String email, String password);

  Future<void> createUserWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  @override
  AppUser? get currentUser => null;

  @override
  Stream<AppUser?> authStateChanges() {
    //TODO update this
    return Stream.value(null);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // TODO implement
  }

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    // TODO implement
  }

  @override
  Future<void> signOut() async {
    // TODO implement
  }
}
