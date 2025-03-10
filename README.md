Prueba SEEK - Aplicación de Autenticación Biométrica y Escaneo QR
==========================================================

Descripción:
-------------
Test de prueba para empresa Seek. Desarrollo de una aplicación móvil en Flutter que permite autenticación biométrica (huella dactilar en Android y Face ID en iOS) y escaneo de códigos QR. Los códigos escaneados se almacenan en un historial persistente mediante Hive.

Funcionalidades:
----------------
- Autenticación biométrica con soporte para PIN de respaldo (Pin de acceso es: 1234).
- Escaneo de códigos QR con procesamiento nativo.
- Historial de códigos QR escaneados, almacenados en local.
- Gestión de estado con BLoC.
- Comunicación con código nativo mediante Pigeon.
- Pruebas unitarias con Mockito y bloc_test.

Requisitos:
-----------
- Flutter SDK 3.x o superior.
- Dart SDK.
- Android Studio y/o Xcode (para compilar en dispositivos).
- CocoaPods (para iOS).
- Una cuenta de Apple Developer (para TestFlight).

Instalación y Configuración:
----------------------------
1. Clonar el repositorio:
   git clone https://github.com/philipx2/seek.git
   cd seek

2. Instalar dependencias:
   flutter pub get

3. Generar código nativo con Pigeon:
   dart run pigeon --input lib/pigeon/native_functions.dart --dart_out lib/pigeon/native_functions.g.dart --kotlin_out android/app/src/main/kotlin/com/example/seek/NativeFunctions.kt --swift_out ios/Runner/NativeFunctions.swift

4. Para ejecutar en Android:
   flutter run

5. Para ejecutar en iOS (solo en Mac):
   cd ios
   pod install
   cd ..
   flutter run

Ejecución de Pruebas:
---------------------
Para ejecutar las pruebas unitarias:
   flutter test

Uso de la Aplicación:
---------------------
1. Iniciar sesión con autenticación biométrica o PIN.
2. Escanear un código QR presionando el botón de escaneo.
3. Ver el código escaneado en pantalla y acceder al historial.

Despliegue en TestFlight y Play Store:
--------------------------------------
- **iOS (TestFlight)**:
  flutter build ios
  fastlane beta

- **Android (Google Play)**:
  flutter build apk --release

Estructura del Proyecto:
------------------------
seek/
 ├── lib/               (Código principal de la app)
 │   ├── blocs/         (Gestión de estado)
 │   ├── screens/       (Interfaz de usuario)
 │   ├── services/      (Autenticación biométrica y QR)
 │   ├── pigeon/        (Código generado con Pigeon)
 │   ├── main.dart      (Punto de entrada de la app)
 │
 ├── android/           (Código nativo en Kotlin)
 ├── ios/               (Código nativo en Swift)
 ├── test/              (Pruebas unitarias)
 ├── pubspec.yaml       (Dependencias)
 ├── README.txt         (Este archivo)

Autor:
------
Desarrollado por Felipe Munoz Bello
Contacto: [felipe.munozbello.13@sansano.usm.cl]
GitHub: https://github.com/tu-usuario

Detalles:
---------
El proyecto no pudo ser probado en testFlight debido a que no tengo los implementos requeridos para el lanzamiento prueba en iOS (Tengo cuenta pero caducó mi suscripción como developer y no tengo Mac)
