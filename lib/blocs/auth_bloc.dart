import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pigeon/native_functions.g.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class PinEntered extends AuthEvent {
  final String pin;
  PinEntered(this.pin);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final BiometricAuthApi _nativeBioAuth = BiometricAuthApi();
  static const MethodChannel _channel = MethodChannel("biometric_auth_channel");

  AuthBloc() : super(AuthInitial()) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "onBiometricResult") {
        final bool isAuthenticated = call.arguments as bool;

        print("Flutter recibió respuesta: $isAuthenticated");

        if (isAuthenticated) {
          add(AuthSuccessEvent());
        } else {
          add(AuthFailureEvent("no auth"));
        }
      }
    });

    on<CheckBiometricAvailability>((event, emit) async {
      bool isAvailable = await _nativeBioAuth.isBiometricAvailable();
      if (isAvailable) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("no authCheckin"));
      }
    });

    on<AuthenticateUser>((event, emit) async {
      emit(AuthLoading());

      _nativeBioAuth.authenticate();
    });

    on<AuthSuccessEvent>((event, emit) {
      emit(AuthSuccess());
    });

    on<AuthFailureEvent>((event, emit) {
      emit(AuthFailure(event.message));
    });

    on<PinEntered>((event, emit) {
      if (event.pin == "1234") {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("PIN incorrecto"));
      }
    });
  }
}

class AuthSuccessEvent extends AuthEvent {}

class AuthFailureEvent extends AuthEvent {
  final String message;
  AuthFailureEvent(this.message);
}
