import 'package:flutter/material.dart';

class ResetConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Link Sent')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email, size: 100, color: Colors.blue),
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
              child: Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
