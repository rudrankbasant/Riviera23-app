part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}



class NotSignedInState extends AuthState {}

class SignInSuccess extends AuthState {

  final User currentUser;

  SignInSuccess({required this.currentUser});

  @override
  List<Object> get props => [currentUser];


}

class AuthLoading extends AuthState {}





class SignInFailed extends AuthState {
  final String error;

  SignInFailed({required this.error});
}
