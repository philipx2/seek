import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class QRScannerApi {
  void startScanQRCode();
  String getLastScannedQRCode();
}

@HostApi()
abstract class BiometricAuthApi {
  bool isBiometricAvailable();
  void authenticate();
}
