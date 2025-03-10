import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:seek/blocs/qr_bloc.dart';
import 'package:seek/blocs/qr_event.dart';
import 'package:seek/blocs/qr_state.dart';
import 'package:seek/services/qr_service.dart';

import '../mocks/mocks.mocks.dart';

@GenerateMocks([QRService])
void main() {
  late QRBloc qrBloc;
  late MockQRService mockQRService;

  setUp(() {
    mockQRService = MockQRService();
    qrBloc = QRBloc();
  });

  tearDown(() {
    qrBloc.close();
  });

  test('El estado inicial debe ser QRInitial', () {
    expect(qrBloc.state, isA<QRInitial>());
  });

  blocTest<QRBloc, QRState>(
    'Debe emitir [QRLoading, QRSuccess] cuando el escaneo es exitoso',
    build: () {
      when(mockQRService.scanQRCode())
          .thenAnswer((_) async => "Código QR Escaneado");
      return qrBloc;
    },
    act: (bloc) => bloc.add(ScanQRCode()),
    expect: () => [QRLoading(), QRSuccess("Código QR Escaneado")],
  );

  blocTest<QRBloc, QRState>(
    'Debe emitir [QRLoading, QRFailure] cuando el escaneo falla',
    build: () {
      when(mockQRService.scanQRCode())
          .thenThrow(Exception("Error al escanear"));
      return qrBloc;
    },
    act: (bloc) => bloc.add(ScanQRCode()),
    expect: () => [QRLoading(), QRFailure("Error al escanear QR")],
  );
}
