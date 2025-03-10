import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';
import 'qr_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _pinController = TextEditingController();
  final String _correctPin = "1234"; // PIN de respaldo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Biométrico")),
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => QRScreen()),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Autenticación fallida")),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is AuthLoading) CircularProgressIndicator(),
                  Text("Usar biometría o ingresar PIN"),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context)
                          .add(AuthenticateUser());
                    },
                    child: Text("Autenticarse"),
                  ),
                  if (state is AuthFailure) ...[
                    TextField(
                      controller: _pinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Ingresar PIN"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_pinController.text == _correctPin) {
                          BlocProvider.of<AuthBloc>(context)
                              .add(PinEntered(_pinController.text));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("PIN incorrecto")),
                          );
                        }
                      },
                      child: Text("Ingresar PIN"),
                    ),
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
