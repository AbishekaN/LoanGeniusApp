import 'package:flutter/material.dart';

class ResetConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Link Sent',
          style: TextStyle(color: Colors.white), // Set AppBar text color to white
        ),
        backgroundColor: Colors.blue, // Set AppBar background color to blue
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white, // Set arrow (icon) color to white
          onPressed: () {
            Navigator.pop(context); // Navigate back when the arrow is pressed
          },
        ),
      ),
      body: Container(
        color: Colors.white, // Set the background color of the entire form to white
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email, size: 100, color: Colors.blue), // Blue email icon
            SizedBox(height: 20),
            Text(
              'A reset password link has been sent to your email.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Please check your mailbox and follow the instructions to reset your password.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');  // Redirect to login page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // White background for the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0, // Remove shadow
              ),
              child: Text(
                'Back to Login',
                style: TextStyle(
                  color: Colors.blue, // Blue text for the button
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
