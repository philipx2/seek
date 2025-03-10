import '../pigeon/native_functions.g.dart';

class BiometricService {
  final BiometricAuthApi _biometricAuthApi = BiometricAuthApi();

  Future<bool> isBiometricAvailable() async {
    return await _biometricAuthApi.isBiometricAvailable();
  }

  Future<void> authenticate() async {
    return await _biometricAuthApi.authenticate();
  }
}
