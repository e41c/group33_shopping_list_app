// group33_shopping_list_app/lib/screens/tax_calculator_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String id;
  String name;
  double price;

  Item({this.id = '', required this.name, required this.price});

  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Item(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
    );
  }
}

class TaxCalculatorScreen extends StatefulWidget {
  @override
  _TaxCalculatorScreenState createState() => _TaxCalculatorScreenState();
}

class _TaxCalculatorScreenState extends State<TaxCalculatorScreen> {
  List<Item> shoppingItems = [];
  double taxRate = 0.0;
  double totalBeforeTax = 0.0;
  double totalAfterTax = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() {
    FirebaseFirestore.instance.collection('items').snapshots().listen((snapshot) {
      setState(() {
        shoppingItems = snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();
        _calculateTotal();
      });
    });
  }

  void _calculateTotal() {
    totalBeforeTax = shoppingItems.fold(0.0, (prev, item) => prev + item.price);
    totalAfterTax = totalBeforeTax + (totalBeforeTax * taxRate / 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tax Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: shoppingItems.length,
              itemBuilder: (context, index) {
                final item = shoppingItems[index];
                return ListTile(
                  title: Text('${item.name} - \$${item.price.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  taxRate = double.tryParse(value) ?? 0.0;
                  _calculateTotal();
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter tax rate (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Total Before Tax: \$${totalBeforeTax.toStringAsFixed(2)}'),
                Text('Total After Tax: \$${totalAfterTax.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
