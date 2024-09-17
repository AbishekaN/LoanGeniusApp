import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();  // New controller for the Name field
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _employeeIdController = TextEditingController(); // Bank officer's Employee ID
  final _phoneController = TextEditingController(); // Bank officer's phone number
  final _branchController = TextEditingController(); // Bank officer's branch
  final _designationController = TextEditingController(); // Bank officer's designation

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false; // Loading state

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

  // Updated _signup function to include Firestore and SnackBar styling
  Future<void> _signup() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Create a new Firebase user
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Store additional bank officer details in Firestore
        await FirebaseFirestore.instance
            .collection('officers') // Collection name in Firestore
            .doc(userCredential.user!.uid) // Document ID (user ID)
            .set({
          'name': _nameController.text,  // Include the name field
          'email': _emailController.text,
          'employee_id': _employeeIdController.text,
          'phone': _phoneController.text,
          'branch': _branchController.text,
          'designation': _designationController.text,
        });

        // Show success message
        _showSnackBar('Registration successful!', Colors.green);

        // Navigate to the login screen after successful signup
        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        } else {
          message = 'Error: ${e.message}';
        }
        // Show error message
        _showSnackBar(message, Colors.red);
      } catch (e) {
        // Handle any other errors
        _showSnackBar('An unexpected error occurred. Please try again.', Colors.red);
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    } else {
      _showSnackBar('Passwords do not match.', Colors.orange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registration',
          style: TextStyle(color: Colors.white), // White text color
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue, // Match the button's color
      ),
      body: Container(
        color: Colors.white, // Set the background color of the entire form to white
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name input
                _buildTextField(_nameController, 'Name', Icons.person), // New Name input field
                SizedBox(height: 16),
                // Email input
                _buildTextField(_emailController, 'Email', Icons.email),
                SizedBox(height: 16),
                // Password input
                _buildTextField(_passwordController, 'Password', Icons.lock, isPassword: true),
                SizedBox(height: 16),
                // Confirm Password input
                _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock_outline, isPassword: true),
                SizedBox(height: 16),
                // Employee ID input
                _buildTextField(_employeeIdController, 'Employee ID', Icons.badge),
                SizedBox(height: 16),
                // Phone Number input
                _buildTextField(_phoneController, 'Phone Number', Icons.phone),
                SizedBox(height: 16),
                // Branch input
                _buildTextField(_branchController, 'Branch', Icons.location_on),
                SizedBox(height: 16),
                // Designation input
                _buildTextField(_designationController, 'Designation', Icons.work),
                SizedBox(height: 30),
                // Register button
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue, // Blue background for register button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // White text for register button
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Already have an account?
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    'Already have an account? Log in here.',
                    style: TextStyle(
                      color: Colors.blue, // Blue text
                      fontSize: 16,
                      decoration: TextDecoration.none, // No underline
                    ),
                    textAlign: TextAlign.center, // Center the text
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build input fields with icons and labels
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
