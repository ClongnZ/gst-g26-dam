import 'package:flutter/material.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis gastos')),
      body: Center( //Placeholder para el resumen y lista de gastos
        child: Text('Aquí se muestra el resumen y lista de gastos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navega a la pantall para agregar gastos
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
