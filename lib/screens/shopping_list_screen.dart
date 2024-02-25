// group33_shopping_list_app/lib/screens/shopping_list_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class Item {
  String id; // Added to hold Firestore document ID
  String name;
  double price;
  String group;

  Item({this.id = '', required this.name, required this.price, required this.group});

  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Item(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      group: data['group'] ?? '',
    );
  }
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
      await FirebaseFirestore.instance.collection('items').add({
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'group': _selectedGroup ?? groups.first,
      });

      // Clear the input fields and reset the dropdown after the item is added
      _nameController.clear();
      _priceController.clear();
      setState(() => _selectedGroup = null);

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added successfully')));
    }
  }

  Stream<List<Item>> _fetchItems() {
    return FirebaseFirestore.instance.collection('items').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
  }

  void _deleteItem(String id) async {
    await FirebaseFirestore.instance.collection('items').doc(id).delete();
  }

  Future<void> _showEditItemDialog(Item item) async {
    _nameController.text = item.name;
    _priceController.text = item.price.toString();
    _selectedGroup = item.group;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Enter item name"),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(hintText: "Enter price"),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedGroup,
                  hint: Text('Select a Group'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGroup = newValue;
                    });
                  },
                  items: groups.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                if (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty && _selectedGroup != null) {
                  await FirebaseFirestore.instance.collection('items').doc(item.id).update({
                    'name': _nameController.text,
                    'price': double.parse(_priceController.text),
                    'group': _selectedGroup,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
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
        title: const Text('Shopping List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Item>>(
              stream: _fetchItems(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final items = snapshot.data!;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text('${item.name} - \$${item.price.toStringAsFixed(2)} (${item.group})'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showEditItemDialog(item),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteItem(item.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
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
        ],
      ),
    );
  }
}
