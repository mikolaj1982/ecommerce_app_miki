import 'package:ecommerce_app_miki/src/features/authentication/domain/app_user_model.dart';

class FakeAppUser extends AppUser {
  final String password;

  const FakeAppUser({
    required super.uid,
    required super.email,
    required this.password,
  });

  @override
  String toString() => 'AppUser(uid: $uid, email: $email, password: $password)';
}
