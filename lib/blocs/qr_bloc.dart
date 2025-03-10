import 'package:flutter_bloc/flutter_bloc.dart';
import '../pigeon/native_functions.g.dart';
import 'qr_event.dart';
import 'qr_state.dart';
import 'dart:async';

class QRBloc extends Bloc<QREvent, QRState> {
  final QRScannerApi _qrScannerApi = QRScannerApi();
  final List<String> _history = [];

  QRBloc() : super(QRInitial()) {
    on<ScanQRCode>((event, emit) async {
      emit(QRLoading());

      try {
        _qrScannerApi.startScanQRCode();
        await Future.delayed(Duration(seconds: 2));

        String result = "";
        int retries = 0;
        int maxRetries = 10;

        while (result.isEmpty && retries < maxRetries) {
          await Future.delayed(Duration(milliseconds: 500));
          result = await _qrScannerApi.getLastScannedQRCode();
          retries++;
        }

        if (result.isNotEmpty) {
          _history.add(result);

          emit(QRInitial()); // ✅ Forzar un refresh
          await Future.delayed(
              Duration(milliseconds: 100)); // ✅ Pequeño delay para refrescar

          emit(QRSuccess(result));
          emit(QRHistoryLoaded(List.from(_history)));
        } else {
          emit(QRFailure("No se pudo obtener el código QR"));
        }
      } catch (e) {
        emit(QRFailure("Error al escanear QR"));
      }
    });

    on<LoadQRHistory>((event, emit) {
      emit(QRHistoryLoaded(List.from(_history)));
    });
  }
}
