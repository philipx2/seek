import Flutter
import UIKit
import AVFoundation

class QRScannerApiImpl: NSObject, QRScannerApi {
    private let channel: FlutterMethodChannel
    private var lastScannedQRCode: String = ""

    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }

    func startScanQRCode() {
        DispatchQueue.main.async {
            let scannerVC = QRScannerViewController(api: self)
            let rootVC = UIApplication.shared.windows.first?.rootViewController
            rootVC?.present(scannerVC, animated: true, completion: nil)
        }
    }

    func getLastScannedQRCode() -> String {
        return lastScannedQRCode
    }

    func sendQRCodeToFlutter(result: String) {
        lastScannedQRCode = result
        channel.invokeMethod("onQRScanned", arguments: result)
    }
}
