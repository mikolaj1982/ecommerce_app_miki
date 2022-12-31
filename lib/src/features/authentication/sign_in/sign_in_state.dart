import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_form_type.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// state classes should be immutable
/// make all properties final
/// you can also marked class as @immutable
@immutable
class SignInState with EmailAndPasswordValidators {
  final AsyncValue<void> value;
  final SignInFormType formType;

  SignInState({
    this.formType = SignInFormType.signIn,
    this.value = const AsyncValue.data(null),
  });

  bool get isLoading => value.isLoading;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SignInState && runtimeType == other.runtimeType && value == other.value && formType == other.formType);

  @override
  int get hashCode => value.hashCode ^ formType.hashCode;

  @override
  String toString() {
    return 'SignInState{' + ' value: $value,' + ' formType: $formType,' + '}';
  }

  SignInState copyWith({
    AsyncValue<void>? value,
    SignInFormType? formType,
  }) {
    return SignInState(
      value: value ?? this.value,
      formType: formType ?? this.formType,
    );
  }
}
