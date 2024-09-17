import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCustomerScreen extends StatefulWidget {
  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nicController = TextEditingController();
  String? _gender;
  String? _maritalStatus;
  String? _employmentStatus;
  final _dependantsController = TextEditingController();
  final _currentLoansController = TextEditingController();

  bool _isLoading = false;

  // Function to show a styled SnackBar for notifications
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

  // Function to validate input fields
  bool _validateFields() {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _nicController.text.isEmpty ||
        _gender == null ||
        _maritalStatus == null ||
        _employmentStatus == null) {
      _showSnackBar('Please fill in all required fields.', Colors.red);
      return false;
    }
    return true;
  }

  // Function to save customer details in Firestore
  Future<void> _saveCustomer() async {
    if (!_validateFields()) return; // Stop if validation fails

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('customers').add({
        'name': _nameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'nic': _nicController.text,
        'gender': _gender,
        'marital_status': _maritalStatus,
        'employment_status': _employmentStatus,
        'dependants': _dependantsController.text,
        'current_loans': _currentLoansController.text,
      });

      _showSnackBar('Customer added successfully!', Colors.green);

      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      print("Error adding customer: $e");
      _showSnackBar('Failed to add customer. Please try again.', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Customer',
          style: TextStyle(color: Colors.white), // Set AppBar text color to white
        ),
        backgroundColor: Colors.blue, // Set the app bar color to blue
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white, // Set back arrow color to white
          onPressed: () {
            Navigator.pop(context); // Navigate back when the arrow is pressed
          },
        ),
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Removed empty Text widget and the unnecessary SizedBox

              _buildTextField(_nameController, 'Customer Name', Icons.person),
              SizedBox(height: 16),
              _buildTextField(_addressController, 'Address', Icons.location_on),
              SizedBox(height: 16),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone),
              SizedBox(height: 16),
              _buildTextField(_nicController, 'NIC No', Icons.credit_card),
              SizedBox(height: 16),

              _buildDropdown('Gender', ['Male', 'Female', 'Other'], (value) {
                setState(() {
                  _gender = value;
                });
              }),
              SizedBox(height: 16),

              _buildDropdown('Marital Status', ['Single', 'Married', 'Divorced', 'Widowed'], (value) {
                setState(() {
                  _maritalStatus = value;
                });
              }),
              SizedBox(height: 16),

              _buildDropdown('Employment Status', ['Employed', 'Unemployed', 'Self-Employed'], (value) {
                setState(() {
                  _employmentStatus = value;
                });
              }),
              SizedBox(height: 16),

              _buildTextField(_dependantsController, 'Dependants', Icons.people),
              SizedBox(height: 16),
              _buildTextField(_currentLoansController, 'Current Loans', Icons.monetization_on),
              SizedBox(height: 30),

              ElevatedButton(
                onPressed: _saveCustomer,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue, // Blue background for the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Save Customer',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // White text for the button
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent), // Blue icon color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Helper method to build dropdowns
  Widget _buildDropdown(String label, List<String> options, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
