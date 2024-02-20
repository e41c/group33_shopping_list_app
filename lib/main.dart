// group33_shopping_list_app/lib/main.dart
import 'package:flutter/material.dart';
import 'package:group33_shopping_list_app/screens/group_list_screen.dart';
import 'package:group33_shopping_list_app/screens/shopping_list_screen.dart';
import 'package:group33_shopping_list_app/screens/tax_calculator_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NavBar()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/logo.jpg',
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'ShopWise TaxTally',
                style: TextStyle(
                  color: Colors.black, // Changed color to black
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'By: Eric Grigor & Ryan Lee',
                style: TextStyle(
                  color: Colors.black, // Changed color to black
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  final tabs = [
    ShoppingListScreen(),
    TaxCalculatorScreen(),
    GroupListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Shopping List'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Tax Calculator'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Group List'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
