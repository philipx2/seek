package com.example.seek.seek

import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import com.example.seek.QRScannerApi  
import com.example.seek.BiometricAuthApi  

import android.app.Activity
import android.content.Intent
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanOptions
import androidx.activity.result.ActivityResultLauncher

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "biometric_auth_channel"
    private lateinit var methodChannel: MethodChannel
    private lateinit var qrScanner: QRScannerApiImpl

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        Log.d("MainActivity", "MethodChannel registrado correctamente")

        qrScanner = QRScannerApiImpl(this, methodChannel)
        QRScannerApi.setUp(flutterEngine.dartExecutor.binaryMessenger, qrScanner)
        BiometricAuthApi.setUp(flutterEngine.dartExecutor.binaryMessenger, BiometricAuthApiImpl(this, methodChannel))
    }
}

class BiometricAuthApiImpl(
    private val activity: FlutterFragmentActivity,
    private val methodChannel: MethodChannel
) : BiometricAuthApi {

    private val TAG = "BiometricAuth"

    override fun isBiometricAvailable(): Boolean {
        val biometricManager = BiometricManager.from(activity)
        val result = biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG)
        Log.d(TAG, "isBiometricAvailable() -> Resultado: $result")
        return result == BiometricManager.BIOMETRIC_SUCCESS
    }

    override fun authenticate() {
        Log.d(TAG, "authenticate() -> Iniciando autenticación biométrica...")

        if (!isBiometricAvailable()) {
            Log.w(TAG, "authenticate() -> Biométrico NO disponible")
            sendBiometricResultToFlutter(false)
            return
        }

        val executor = ContextCompat.getMainExecutor(activity)

        val biometricPrompt = BiometricPrompt(activity, executor, object : BiometricPrompt.AuthenticationCallback() {
            override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                Log.i(TAG, "onAuthenticationSucceeded() -> Éxito")
                sendBiometricResultToFlutter(true)
            }

            override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                Log.e(TAG, "onAuthenticationError() -> Código: $errorCode, Mensaje: $errString")
                sendBiometricResultToFlutter(false)
            }

            override fun onAuthenticationFailed() {
                Log.w(TAG, "onAuthenticationFailed() -> Falló")
                sendBiometricResultToFlutter(false)
            }
        })

        val promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Autenticación biométrica")
            .setSubtitle("Escanea tu huella para continuar")
            .setNegativeButtonText("Cancelar")
            .build()

        Log.d(TAG, "authenticate() -> Mostrando diálogo biométrico...")
        biometricPrompt.authenticate(promptInfo)
    }

    private fun sendBiometricResultToFlutter(success: Boolean) {
        Log.d(TAG, "sendBiometricResultToFlutter() -> Enviando resultado: $success")
        Handler(Looper.getMainLooper()).post {
            methodChannel.invokeMethod("onBiometricResult", success)
        }
    }
}

class QRScannerApiImpl(private val activity: FlutterFragmentActivity, private val methodChannel: MethodChannel) : QRScannerApi {
    private val TAG = "QRScanner"
    private var lastScannedQRCode: String = ""

    private val scanLauncher: ActivityResultLauncher<ScanOptions> =
        activity.registerForActivityResult(ScanContract()) { result ->
            if (result.contents != null) {
                Log.d(TAG, "Código QR escaneado: ${result.contents}")
                lastScannedQRCode = result.contents 
                sendQRCodeResultToFlutter(result.contents)
            } else {
                Log.d(TAG, "Escaneo cancelado")
                sendQRCodeResultToFlutter("")
            }
        }

    override fun startScanQRCode() {
        val options = ScanOptions().apply {
            setPrompt("Escanea un código QR")
            setBeepEnabled(true)
            setOrientationLocked(false)
            setBarcodeImageEnabled(true)
        }

        Log.d(TAG, "Iniciando escaneo de código QR...")
        scanLauncher.launch(options)
    }

    override fun getLastScannedQRCode(): String {
        Log.d(TAG, "Recuperando último QR escaneado: $lastScannedQRCode")
        return lastScannedQRCode
    }

    private fun sendQRCodeResultToFlutter(result: String) {
        Log.d(TAG, "Enviando resultado a Flutter: $result")
        methodChannel.invokeMethod("onQRScanned", result)
    }
}
