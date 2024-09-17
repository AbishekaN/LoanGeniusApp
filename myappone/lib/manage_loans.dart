import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageLoansScreen extends StatefulWidget {
  @override
  _ManageLoansScreenState createState() => _ManageLoansScreenState();
}

class _ManageLoansScreenState extends State<ManageLoansScreen> {
  final _loanAmountController = TextEditingController();
  final _loanTermController = TextEditingController();
  final _interestRateController = TextEditingController();
  bool _isLoading = false;
  String? _selectedCustomer;

  @override
  void dispose() {
    _loanAmountController.dispose();
    _loanTermController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Loans',
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
        color: Colors.white, // Set form background color to white
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('customers').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final customers = snapshot.data!.docs;

                  return DropdownButtonFormField<String>(
                    value: _selectedCustomer,
                    hint: Text('Select Customer'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Customer',
                    ),
                    items: customers.map((customer) {
                      return DropdownMenuItem<String>(
                        value: customer.id,
                        child: Text(customer['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCustomer = value;
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 16),
              // Loan Amount
              TextField(
                controller: _loanAmountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow numbers and decimal
                ],
                decoration: InputDecoration(
                  labelText: 'Loan Amount',
                  prefixIcon: Icon(Icons.money, color: Colors.blueAccent), // Set icon color to blue
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildTextField(_loanTermController, 'Loan Term (Years)', Icons.calendar_today),
              SizedBox(height: 16),
              _buildTextField(_interestRateController, 'Interest Rate (%)', Icons.percent),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _addLoan,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue, // Blue background for Add Loan button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Add Loan',
                  style: TextStyle(fontSize: 18, color: Colors.white), // White text for Add Loan button
                ),
              ),
              SizedBox(height: 30),
              Divider(),
              // Existing Loans List
              Text('Existing Loans', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('loans').orderBy('createdAt').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No loans found.'));
                  }

                  final loans = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: loans.length,
                    itemBuilder: (context, index) {
                      var loan = loans[index].data() as Map<String, dynamic>;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: ListTile(
                          title: Text('Loan Amount: ${loan['loanAmount']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Term: ${loan['loanTerm']} years'),
                              Text('Interest Rate: ${loan['interestRate']}%'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _editLoan(loans[index].id);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteLoan(loans[index].id, loan['customerId']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
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
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent), // Set icon color to blue
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Function to add a new loan
  Future<void> _addLoan() async {
    if (_selectedCustomer == null ||
        _loanAmountController.text.isEmpty ||
        _loanTermController.text.isEmpty ||
        _interestRateController.text.isEmpty) {
      _showSnackBar('Please fill in all fields', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch the customer document
      var customerSnapshot = await FirebaseFirestore.instance.collection('customers').doc(_selectedCustomer).get();

      // Check if 'currentLoan' exists for this customer, using the `.containsKey` method to avoid error
      if (customerSnapshot.exists && (customerSnapshot.data()?.containsKey('currentLoan') ?? false)) {
        _showSnackBar('Customer already has a loan.', Colors.red);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Add the loan to the 'loans' collection
      await FirebaseFirestore.instance.collection('loans').add({
        'customerId': _selectedCustomer,
        'loanAmount': _loanAmountController.text,
        'loanTerm': _loanTermController.text,
        'interestRate': _interestRateController.text,
        'createdAt': Timestamp.now(),
      });

      // Update the corresponding customer's record to indicate a current loan
      await FirebaseFirestore.instance.collection('customers').doc(_selectedCustomer).update({
        'currentLoan': {
          'loanAmount': _loanAmountController.text,
          'loanTerm': _loanTermController.text,
          'interestRate': _interestRateController.text,
          'loanAddedAt': Timestamp.now(),
        }
      });

      _showSnackBar('Loan added successfully', Colors.green);
      _loanAmountController.clear();
      _loanTermController.clear();
      _interestRateController.clear();
    } catch (e) {
      _showSnackBar('Failed to add loan: $e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to delete a loan
  Future<void> _deleteLoan(String loanId, String customerId) async {
    try {
      // Delete the loan from the 'loans' collection
      await FirebaseFirestore.instance.collection('loans').doc(loanId).delete();

      // Remove the 'currentLoan' field from the customer document
      await FirebaseFirestore.instance.collection('customers').doc(customerId).update({
        'currentLoan': FieldValue.delete(), // Remove the field entirely
      });

      _showSnackBar('Loan deleted successfully', Colors.green);
    } catch (e) {
      _showSnackBar('Failed to delete loan: $e', Colors.red);
    }
  }

  // Function to edit a loan (this can be expanded to allow editing)
  void _editLoan(String loanId) {
    // You can add logic here to edit a loan (similar to how the addLoan works)
  }

  // Function to show a styled SnackBar for success/failure messages
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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor, // Use background color for success message
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
