import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/qr_bloc.dart';
import '../blocs/qr_event.dart';
import '../blocs/qr_state.dart';

class QRScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Escaneo de QR")),
      body: BlocProvider(
        create: (context) =>
            QRBloc()..add(LoadQRHistory()), // ✅ Cargar historial al iniciar
        child: BlocBuilder<QRBloc, QRState>(
          builder: (context, state) {
            if (state is QRLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is QRSuccess || state is QRHistoryLoaded) {
              final history = state is QRHistoryLoaded ? state.history : [];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is QRSuccess) Text("Último QR: ${state.qrText}"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<QRBloc>(context).add(ScanQRCode());
                    },
                    child: Text("Escanear Nuevo QR"),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(history[index]),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<QRBloc>(context).add(ScanQRCode());
                },
                child: Text("Escanear QR"),
              ),
            );
          },
        ),
      ),
    );
  }
}
