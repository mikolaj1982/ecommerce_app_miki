import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

@freezed
class AppException with _$AppException {
  const factory AppException.emailAlreadyInUse() = EmailAlreadyInUse;

  const factory AppException.weakPassword() = WeakPassword;

  const factory AppException.wrongPassword() = WrongPassword;

  const factory AppException.userNotFound() = UserNotFound;

  const factory AppException.cartSyncFailed() = CartSyncFailed;

  const factory AppException.paymentFailureEmptyCart() = PaymentFailureEmptyCart;

  const factory AppException.parseOrderFailure(String status) = ParseOrderFailure;
}

class AppExceptionData {
  final String message;
  final String code;

  AppExceptionData({
    required this.message,
    required this.code,
  });

  @override
  toString() => 'AppExceptionData: {message: $message, code: $code}';
}

extension AppExceptionDetails on AppException {
  AppExceptionData get details {
    return when(
      emailAlreadyInUse: () => AppExceptionData(
        message: 'The email address is already in use by another account.',
        code: 'email-already-in-use',
      ),
      weakPassword: () => AppExceptionData(
        message: 'The password provided is too weak.',
        code: 'weak-password',
      ),
      wrongPassword: () => AppExceptionData(
        message: 'The password is invalid or the user does not have a password.',
        code: 'wrong-password',
      ),
      userNotFound: () => AppExceptionData(
        message: 'No user found for that email.',
        code: 'user-not-found',
      ),
      cartSyncFailed: () => AppExceptionData(
        message: 'Cart sync failed',
        code: 'cart-sync-failed',
      ),
      paymentFailureEmptyCart: () => AppExceptionData(
        message: 'Payment failure: empty cart',
        code: 'payment-failure-empty-cart',
      ),
      parseOrderFailure: (status) => AppExceptionData(
        message: 'Parse order failure',
        code: 'parse-order-failure',
      )
    );
  }
}
