import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerRecordsScreen extends StatefulWidget {
  @override
  _CustomerRecordsScreenState createState() => _CustomerRecordsScreenState();
}

class _CustomerRecordsScreenState extends State<CustomerRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set the app bar color to blue
        title: Text(
          'Records',
          style: TextStyle(color: Colors.white), // Set AppBar text color to white
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white, // Set back arrow color to white
          onPressed: () {
            Navigator.pop(context); // Navigate back when the arrow is pressed
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('customers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No customer records found.'));
          }

          final customerRecords = snapshot.data!.docs;

          return ListView.builder(
            itemCount: customerRecords.length,
            itemBuilder: (context, index) {
              var customer = customerRecords[index].data() as Map<String, dynamic>;
              var currentLoan = customer['currentLoan'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${customer['name'] ?? 'No name'}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Address: ${customer['address'] ?? 'No address'}'),
                      Text('Phone: ${customer['phone'] ?? 'No phone'}'),
                      Text('NIC: ${customer['nic'] ?? 'No NIC'}'),
                      Text('Gender: ${customer['gender'] ?? 'No gender'}'),
                      Text('Marital Status: ${customer['marital_status'] ?? 'No marital status'}'),
                      Text('Employment Status: ${customer['employment_status'] ?? 'No employment status'}'),
                      Text('Dependants: ${customer['dependants'] ?? 'No dependants'}'),
                      SizedBox(height: 16),

                      // Highlighted Current Loan section
                      if (currentLoan != null) ...[
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50], // Light blue background
                            border: Border.all(color: Colors.blue), // Blue border
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Current Loan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                              SizedBox(height: 8),
                              Text('Loan Amount: ${currentLoan['loanAmount']}'),
                              Text('Loan Term: ${currentLoan['loanTerm']} years'),
                              Text('Interest Rate: ${currentLoan['interestRate']}%'),
                              Text('Loan Added At: ${currentLoan['loanAddedAt'].toDate().toString()}'),
                            ],
                          ),
                        ),
                      ] else ...[
                        Text('No Current Loan', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ],
                      SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _editCustomer(customerRecords[index].id, customer);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Blue background for Edit button
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white, // White text for Edit button
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              _showDeleteConfirmationDialog(customerRecords[index].id); // Show confirmation dialog
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Red background for Delete button
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white, // White text for Delete button
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to show a confirmation dialog before deleting a customer
  void _showDeleteConfirmationDialog(String customerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this customer?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey, // Cancel button background color
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteCustomer(customerId); // Call the delete function
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Yes button background color
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to delete a customer
  Future<void> _deleteCustomer(String customerId) async {
    try {
      await FirebaseFirestore.instance.collection('customers').doc(customerId).delete();
      _showSnackBar('Customer deleted successfully', Colors.green); // Show success message
    } catch (e) {
      _showSnackBar('Failed to delete customer: $e', Colors.red); // Show error message
    }
  }

  // Function to show success message
  void _showSnackBar(String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor, // Use blue background for success message
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
  Widget _buildDropdown(String label, List<String> options, void Function(String?) onChanged, {String? initialValue}) {
    return DropdownButtonFormField<String>(
      value: initialValue,
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

  // Function to edit a customer (show a dialog with pre-filled information)
  void _editCustomer(String docId, Map<String, dynamic> customer) {
    TextEditingController _nameController = TextEditingController(text: customer['name']);
    TextEditingController _addressController = TextEditingController(text: customer['address']);
    TextEditingController _phoneController = TextEditingController(text: customer['phone']);
    TextEditingController _nicController = TextEditingController(text: customer['nic']);
    String? _gender = customer['gender'];
    String? _maritalStatus = customer['marital_status'];
    String? _employmentStatus = customer['employment_status'];
    TextEditingController _dependantsController = TextEditingController(text: customer['dependants']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Customer'),
          content: SingleChildScrollView(
            child: Column(
              children: [
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
                }, initialValue: _gender),
                SizedBox(height: 16),
                _buildDropdown('Marital Status', ['Single', 'Married', 'Divorced', 'Widowed'], (value) {
                  setState(() {
                    _maritalStatus = value;
                  });
                }, initialValue: _maritalStatus),
                SizedBox(height: 16),
                _buildDropdown('Employment Status', ['Employed', 'Unemployed', 'Self-Employed'], (value) {
                  setState(() {
                    _employmentStatus = value;
                  });
                }, initialValue: _employmentStatus),
                SizedBox(height: 16),
                _buildTextField(_dependantsController, 'Dependants', Icons.people),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('customers').doc(docId).update({
                  'name': _nameController.text,
                  'address': _addressController.text,
                  'phone': _phoneController.text,
                  'nic': _nicController.text,
                  'gender': _gender,
                  'marital_status': _maritalStatus,
                  'employment_status': _employmentStatus,
                  'dependants': _dependantsController.text,
                });

                Navigator.of(context).pop();
                _showSnackBar('Customer updated successfully', Colors.blue); // Blue success message
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30), // Adjusted padding for button size
                backgroundColor: Colors.blue, // Same blue color as Add Customer button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16, // Adjusted font size to 16
                  color: Colors.white, // White text for the button
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
