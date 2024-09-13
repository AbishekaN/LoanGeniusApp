import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // Function to show a styled SnackBar for success or failure messages
  void _showSnackBar(String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            backgroundColor == Colors.green ? Icons.check_circle_outline : Icons.error_outline,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(16),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _sendPasswordResetLink() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);

      // Show success message
      _showSnackBar('Password reset link sent!', Colors.green);

      // Navigate to the confirmation screen after sending the reset link
      Navigator.pushReplacementNamed(context, '/reset_confirmation');
    } on FirebaseAuthException catch (e) {
      // Show error message
      _showSnackBar('Error: ${e.message}', Colors.red);
    } catch (e) {
      // Show general error message
      _showSnackBar('An unexpected error occurred. Please try again.', Colors.red);
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email input
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _sendPasswordResetLink,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue, // Set background color to blue
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Send Reset Link',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Set text color to white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
