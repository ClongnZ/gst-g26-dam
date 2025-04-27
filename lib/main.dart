import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

//Función principal que inicia la aplicación
void main() {
  //Llama al widget principal
  runApp(GastosApp()); 
}

//Clase principal
class GastosApp extends StatelessWidget {
  const GastosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( //Widget principal, configura la app
      title: 'Gastos personales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal), //Color principal
      home: HomeScreen(), //Establece pantalla principal
    );
  }
}
