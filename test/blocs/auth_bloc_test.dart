import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:seek/blocs/auth_bloc.dart';
import 'package:seek/blocs/auth_event.dart';
import 'package:seek/blocs/auth_state.dart';
import 'package:seek/services/biometric_service.dart';

import '../mocks/mocks.mocks.dart';

@GenerateMocks([BiometricService])
void main() {
  late AuthBloc authBloc;
  late MockBiometricService mockBiometricService;

  setUp(() {
    mockBiometricService = MockBiometricService();
    authBloc = AuthBloc();
  });

  tearDown(() {
    authBloc.close();
  });

  test('El estado inicial debe ser AuthInitial', () {
    expect(authBloc.state, isA<AuthInitial>());
  });

  blocTest<AuthBloc, AuthState>(
    'Debe emitir [AuthLoading, AuthSuccess] cuando la autenticación es exitosa',
    build: () {
      when(mockBiometricService.authenticate()).thenAnswer((_) async => true);
      return authBloc;
    },
    act: (bloc) => bloc.add(AuthenticateUser()),
    expect: () => [AuthLoading(), AuthSuccess()],
  );

  blocTest<AuthBloc, AuthState>(
    'Debe emitir [AuthLoading, AuthFailure] cuando la autenticación falla',
    build: () {
      when(mockBiometricService.authenticate()).thenAnswer((_) async => false);
      return authBloc;
    },
    act: (bloc) => bloc.add(AuthenticateUser()),
    expect: () => [AuthLoading(), AuthFailure("Autenticación fallida")],
  );
}
