// group33_shopping_list_app/lib/screens/tax_calculator_screen.dart
import 'package:flutter/material.dart';

class TaxCalculatorScreen extends StatefulWidget {
  @override
  _TaxCalculatorScreenState createState() => _TaxCalculatorScreenState();
}

class _TaxCalculatorScreenState extends State<TaxCalculatorScreen> {
  List<Map<String, dynamic>> shoppingItems = [];
  double taxRate = 0.0;
  double subtotal = 0.0;
  double total = 0.0;

  void _addItem() {
    setState(() {
      int index = shoppingItems.length;
      shoppingItems.add({'name': 'Item ${index + 1}', 'price': 10.0, 'checked': false});
    });
  }

  void _calculateTax() {
    setState(() {
      subtotal = shoppingItems.where((item) => item['checked']).fold(0.0, (prev, item) => prev + item['price']);
      total = subtotal + subtotal * taxRate / 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Logo'),
            Text('Group Management'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: shoppingItems.length,
              itemBuilder: (context, index) => ListTile(
                leading: Checkbox(
                  value: shoppingItems[index]['checked'], 
                  onChanged: (value) {
                    setState(() {
                      shoppingItems[index]['checked'] = value;
                    });
                  }
                ),
                title: Text('${shoppingItems[index]['name']} - \$${shoppingItems[index]['price'].toStringAsFixed(2)}'),
                trailing:
                    IconButton(icon: Icon(Icons.delete), onPressed: () {
                  setState(() {
                    shoppingItems.removeAt(index);
                  });
                }),
              ),
            ),
          ),
          ElevatedButton(onPressed:_addItem, child :Text("Add Item")),
          Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
          TextField(
            onChanged: (value) {
              setState(() {
                taxRate = double.parse(value);
              });
            },
            decoration: InputDecoration(
              labelText: 'Enter tax rate',
            ),
          ),
          ElevatedButton(onPressed:_calculateTax, child :Text("Calculate Tax")),
          Text('Total: \$${total.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}