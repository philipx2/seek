import '../pigeon/native_functions.g.dart';

class QRService {
  final QRScannerApi _qrScannerApi = QRScannerApi();

  Future<String> scanQRCode() async {
    return await _qrScannerApi.getLastScannedQRCode();
  }
}
