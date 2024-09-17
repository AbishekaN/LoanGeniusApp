import 'package:flutter/material.dart';
import 'dart:async'; // To use Timer for splash duration
import 'signup.dart'; // Import your SignupScreen

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();

    // Timer to automatically move to SignupScreen after 3 seconds
    Timer(Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignupScreen()), // Navigate to Signup
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Remove the logo line since it was causing issues, if you want to add it back make sure it works
            SizedBox(height: 20),
            Text(
              'Loan Genius',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator( // A loading spinner for splash screen
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
