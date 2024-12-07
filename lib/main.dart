import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practiceflutter/firebase_options.dart';
import 'package:practiceflutter/pages/HomeScreen.dart';
void main() async {
  // Asegúrate de inicializar los bindings antes de cualquier otra cosa
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones de la plataforma actual
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configura la apariencia de la barra de estado
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 255, 255, 255), // Barra de estado transparente
      statusBarIconBrightness: Brightness.dark, // Íconos de la barra de estado oscuros
    ),
  );

  // Configura la persistencia de Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
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
