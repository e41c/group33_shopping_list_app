// group33_shopping_list_app/lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:group33_shopping_list_app/screens/shopping_list_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    // Navigate to ShoppingListScreen after a delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ShoppingListScreen()),
      );
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
                'Welcome',
                style: TextStyle(
                  color: Colors.black, // Changed color to black
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'App Loading...',
                style: TextStyle(
                  color: Colors.black, // Changed color to black
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 20.0),
              CircularProgressIndicator(
                value: _animation.value,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
