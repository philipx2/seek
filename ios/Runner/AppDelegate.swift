import UIKit
import Flutter
import LocalAuthentication

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let channelName = "biometric_auth_channel"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "biometric_auth_channel", binaryMessenger: controller.binaryMessenger)
        
        BiometricAuthApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: BiometricAuthApiImpl(channel: methodChannel))
        QRScannerApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: QRScannerApiImpl(channel: methodChannel))

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func authenticate(result: @escaping FlutterResult) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Autenticación biométrica requerida para continuar."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        result(true)
                    } else {
                        result(false)
                    }
                }
            }
        } else {
            result(false)
        }
    }
}

