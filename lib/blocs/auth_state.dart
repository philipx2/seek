abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message); // Agregamos el mensaje en el constructor
}

class AuthLoading extends AuthState {}
