//import 'dart:io';

import 'package:flutter/material.dart';
import 'add_expense_screen.dart';
import '../db/database_helper.dart';
import '../models/expense.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final expenses = await DatabaseHelper().getExpenses();
    setState(() {
      _expenses = expenses;
    });
  }

  double _calculateTotal() {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  Future<void> _deleteExpense(int id) async {
    await DatabaseHelper().deleteExpense(id);
    _loadExpenses(); //Actualiza la lista de gastos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis gastos')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  'Gasto total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '\$${_calculateTotal().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, color: Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child:
                  _expenses.isEmpty
                      ? Center(child: Text('No hay gastos registrados'))
                      : ListView.builder(
                        itemCount: _expenses.length,
                        itemBuilder: (context, index) {
                          final exp = _expenses[index];
                          return Card(
                            child: ListTile(
                              title: Text(exp.description),
                              subtitle: Text('${exp.category} - ${exp.date}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('\$${exp.amount.toStringAsFixed(2)}'),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => _confirmDelete(exp.id!),
                                  ),
                                ],
                              ),
                              //Navega a la pantalla de edición al hacer clic sobre un gasto
                              onTap: () async { 
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            AddExpenseScreen(expense: exp),
                                  ),
                                );
                                _loadExpenses();
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
          _loadExpenses(); //Recarga la lista al volver
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('¿Eliminar gasto?'),
            content: Text('Esta acción no se puede deshacer.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _deleteExpense(id);
                },
                child: Text('Eliminar'),
              ),
            ],
          ),
    );
  }
}
