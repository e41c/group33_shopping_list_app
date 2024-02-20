// group33_shopping_list_app/lib/screens/shopping_list_screen.dart
import 'package:flutter/material.dart';

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<Map<String, dynamic>> shoppingItems = [];

  void _addItem() {
    setState(() {
      int index = shoppingItems.length;
      shoppingItems.add({'name': 'Item ${index + 1}', 'price': 10.0, 'checked': false});
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
        ],
      ),
    );
  }
}