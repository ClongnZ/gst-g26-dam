
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //Paquete para formatear fechas
import '../db/database_helper.dart';
import '../models/expense.dart';

//Pantalla para agregar nuevos gastos
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  //Controladores para los campos de texto
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Comida'; //Categoría por defecto
  DateTime _selectedDate = DateTime.now(); //Fecha por defecto

  //Lista de categorías disponibles
  final List<String> _categories = [
    'Comida',
    'Transporte',
    'Entretenimiento',
    'Salud',
    'Otros',
  ];

  //Método para guardar el gasto
  void _submitExpense() async {
    if (_formKey.currentState!.validate()) { //Valida los campos del formulario
      Expense expense = Expense( //Crea un objeto Expense con los datos del formulario
        description: _descriptionController.text,
        category: _selectedCategory,
        amount: double.parse(_amountController.text),
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      );

      await DatabaseHelper().insertExpense(expense); //Guarda la base de datos
      Navigator.pop(context); //Regresa a la pantalla anterior
    }
  }

  //Método para seleccionar fecha
  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; //Actualiza la fecha
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar gasto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, 
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Ingrese una descripción' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator:
                    (value) =>
                        value!.isEmpty || double.tryParse(value) == null
                            ? 'Ingrese un monto válido'
                            : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items:
                    _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged:
                    (value) => setState(() => _selectedCategory = value!),
                decoration: InputDecoration(labelText: 'Categoría'),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Fecha: ${DateFormat('yyy-MM-dd').format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text('Cambiar fecha'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitExpense,
                child: Text('Guardar Gasto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
