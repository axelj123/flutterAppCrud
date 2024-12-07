import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practiceflutter/pages/HomeScreen.dart';

void main() {
  // Configura la barra de estado como transparente
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:
          Color.fromARGB(255, 255, 255, 255), // Barra de estado transparente
      statusBarIconBrightness:
          Brightness.dark, // Íconos de la barra de estado oscuros
    ),
  );

  // Inicia la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: Colors.black),
          scaffoldBackgroundColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
            floatingLabelStyle: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 0, 0, 0),
                width: 2.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            helperStyle: TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
            ),
          ),
     
          ),
      home: const HomeScreen(),
    );
  }
}
