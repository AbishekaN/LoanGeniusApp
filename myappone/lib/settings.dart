import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myappone/Faqs.dart'; // Import the FAQ screen

class SettingsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to show logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey)), // Cancel action
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(context); // Call logout function
              },
              child: Text('Logout', style: TextStyle(color: Colors.red)), // Confirm logout
            ),
          ],
        );
      },
    );
  }

  // Function to handle log out
  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();

      // Navigate to login page immediately after logging out
      Navigator.pushReplacementNamed(context, '/login');

    } catch (e) {
      print("Error logging out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white), // Set AppBar text color to white
        ),
        backgroundColor: Colors.blue, // Set AppBar background color to blue
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white, // Set back arrow color to white
          onPressed: () {
            Navigator.pop(context); // Navigate back when the arrow is pressed
          },
        ),
      ),
      body: Container(
        color: Colors.white, // Set the form background color to white
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile Settings'),
              onTap: () {
                // Navigate to Profile Settings Screen
                Navigator.pushNamed(context, '/profile_settings');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Privacy & Security'),
              onTap: () {
                // Navigate to Privacy & Security Screen
                Navigator.pushNamed(context, '/privacy_settings');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('FAQs'),
              onTap: () {
                // Navigate to FAQs Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQScreen()),
                );
              },
            ),
            Divider(),
            SizedBox(height: 20),  // Add some spacing between the last tile and the button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () => _showLogoutConfirmationDialog(context), // Show confirmation dialog before logout
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red, // Red button for log out
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Log Out',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
