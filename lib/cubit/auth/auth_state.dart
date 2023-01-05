part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {}

class SignUpState extends AuthState {}

class SignInSuccess extends AuthState {

}

class NotSignedInState extends AuthState {}

class SignInFailed extends AuthState {
  final String error;

  SignInFailed({required this.error});
}
