// group33_shopping_list_app/lib/screens/group_list_screen.dart
import 'package:flutter/material.dart';

class GroupListScreen extends StatefulWidget {
  @override
  _GroupListScreenState createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  List<Map<String, dynamic>> groups = [];

  void _addGroup() {
    setState(() {
      int index = groups.length;
      groups.add({'name': 'Group ${index + 1}', 'items': []});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Text('Logo'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Text('Group Management'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) => ListTile(
                title: Text('${groups[index]['name']} - ${groups[index]['items'].length} items'),
                trailing:
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.edit), onPressed: () {
                          // Implement your group editing functionality here
                        }),
                        IconButton(icon: Icon(Icons.delete), onPressed: () {
                          setState(() {
                            groups.removeAt(index);
                          });
                        }),
                      ],
                    ),
              ),
            ),
          ),
          ElevatedButton(onPressed:_addGroup, child :Text("Add Group")),
        ],
      ),
    );
  }
}
