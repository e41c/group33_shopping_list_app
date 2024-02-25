// group33_shopping_list_app/lib/screens/shopping_list_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class Item {
  String name;
  double price;
  String group;

  Item({required this.name, required this.price, required this.group});
}

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedGroup; // Variable to hold the selected group
  List<String> groups = ['Fruits', 'Bakery', 'Dairy']; // Example groups

  void _addItem() async {
    if (_formKey.currentState!.validate()) {
      final item = Item(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        group: _selectedGroup ?? groups.first, // Default to first group if none selected
      );
      await FirebaseFirestore.instance.collection('items').add({
        'name': item.name,
        'price': item.price,
        'group': item.group,
      });

      // Clear the input fields and reset the dropdown after the item is added
      _nameController.clear();
      _priceController.clear();
      setState(() {
        _selectedGroup = null; // Reset selected group
      });

      // Optionally, show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added successfully')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedGroup,
                hint: Text('Select a Group'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGroup = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a group' : null,
                items: groups.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Add Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
