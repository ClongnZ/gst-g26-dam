import 'package:flutter/material.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar gasto')),
      body: Center(
        //Placeholder para el formulario de registro de gastos
        child: Text('Formulario para agregar gastos')),
    );
  }
}
