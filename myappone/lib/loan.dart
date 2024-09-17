import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'api_service.dart';

class PredictScreen extends StatefulWidget {
  @override
  _PredictScreenState createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  // Text controllers for input fields
  TextEditingController applicantIncomeController = TextEditingController();
  TextEditingController coapplicantIncomeController = TextEditingController();
  TextEditingController loanAmountController = TextEditingController();
  TextEditingController loanTermController = TextEditingController();

  String creditHistory = '1'; // Default to '1' for having credit history
  String gender = '1'; // Male by default
  String married = '1'; // Married by default
  String education = '1'; // Graduate by default
  String selfEmployed = '0'; // Not self-employed by default
  String propertyArea = '1'; // Semiurban by default
  String dependents = '0'; // No dependents by default
  String result = '';
  String probability = ''; // Add this to show probability

  // Function to save loan prediction result to Firestore
  Future<void> saveLoanPredictionResult(String status, String date) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('loanHistory').add({
        'userId': user.uid,
        'status': status,
        'date': date,
      });
    }
  }

  // Function to call API and update the UI
  Future<void> _predictLoanStatus() async {
    if (_formKey.currentState!.validate()) {
      // Create a data map to send to the API
      Map<String, dynamic> data = {
        "ApplicantIncome": int.parse(applicantIncomeController.text),
        "CoapplicantIncome": int.parse(coapplicantIncomeController.text),
        "LoanAmount": int.parse(loanAmountController.text),
        "Loan_Amount_Term": int.parse(loanTermController.text),
        "Credit_History": int.parse(creditHistory),
        "Gender": int.parse(gender),
        "Married": int.parse(married),
        "Dependents_0": dependents == '0' ? 1 : 0,
        "Dependents_1": dependents == '1' ? 1 : 0,
        "Dependents_2": dependents == '2' ? 1 : 0,
        "Dependents_3+": dependents == '3+' ? 1 : 0,
        "Education": int.parse(education),
        "Self_Employed": int.parse(selfEmployed),
        "Property_Area_Rural": propertyArea == '0' ? 1 : 0,
        "Property_Area_Semiurban": propertyArea == '1' ? 1 : 0,
        "Property_Area_Urban": propertyArea == '2' ? 1 : 0,
      };

      try {
        // Call the API service and await the result
        Map<String, dynamic> apiResult = await apiService.predictLoanStatus(data);

        // Update the UI with the result and probability
        setState(() {
          result = apiResult['loan_status'];
          probability = double.parse(apiResult['probability'].toString()).toStringAsFixed(2);
        });

        // Save the prediction result to Firestore
        String currentDate = DateTime.now().toIso8601String();
        saveLoanPredictionResult(result, currentDate);
      } catch (e) {
        // Handle any errors
        setState(() {
          result = 'Error occurred: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Loan Prediction',
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
        color: Colors.white, // Set the background to white
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Text header
                Text(
                  'Enter Your Loan Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                // Applicant Income field
                _buildInputField(
                  controller: applicantIncomeController,
                  labelText: 'Applicant Income',
                  icon: Icons.monetization_on,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Coapplicant Income field
                _buildInputField(
                  controller: coapplicantIncomeController,
                  labelText: 'Coapplicant Income',
                  icon: Icons.monetization_on,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Loan Amount field
                _buildInputField(
                  controller: loanAmountController,
                  labelText: 'Loan Amount',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Loan Term field
                _buildInputField(
                  controller: loanTermController,
                  labelText: 'Loan Term (days)',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Dropdown for Credit History
                _buildDropdownField(
                  value: creditHistory,
                  labelText: 'Credit History',
                  icon: Icons.credit_card,
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Has Credit History')),
                    DropdownMenuItem(value: '0', child: Text('No Credit History')),
                  ],
                  onChanged: (newValue) => setState(() {
                    creditHistory = newValue!;
                  }),
                ),
                SizedBox(height: 16),

                // Dropdown for Gender
                _buildDropdownField(
                  value: gender,
                  labelText: 'Gender',
                  icon: Icons.person,
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Male')),
                    DropdownMenuItem(value: '0', child: Text('Female')),
                  ],
                  onChanged: (newValue) => setState(() {
                    gender = newValue!;
                  }),
                ),
                SizedBox(height: 16),

                // Dropdown for Marital Status
                _buildDropdownField(
                  value: married,
                  labelText: 'Marital Status',
                  icon: Icons.people,
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Married')),
                    DropdownMenuItem(value: '0', child: Text('Not Married')),
                  ],
                  onChanged: (newValue) => setState(() {
                    married = newValue!;
                  }),
                ),
                SizedBox(height: 16),

                // Dropdown for Dependents
                _buildDropdownField(
                  value: dependents,
                  labelText: 'Dependents',
                  icon: Icons.family_restroom,
                  items: [
                    DropdownMenuItem(value: '0', child: Text('0')),
                    DropdownMenuItem(value: '1', child: Text('1')),
                    DropdownMenuItem(value: '2', child: Text('2')),
                    DropdownMenuItem(value: '3+', child: Text('3+')),
                  ],
                  onChanged: (newValue) => setState(() {
                    dependents = newValue!;
                  }),
                ),
                SizedBox(height: 16),

                // Dropdown for Education
                _buildDropdownField(
                  value: education,
                  labelText: 'Education',
                  icon: Icons.school,
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Graduate')),
                    DropdownMenuItem(value: '0', child: Text('Not Graduate')),
                  ],
                  onChanged: (newValue) => setState(() {
                    education = newValue!;
                  }),
                ),
                SizedBox(height: 16),

                // Dropdown for Self-Employed
                _buildDropdownField(
                  value: selfEmployed,
                  labelText: 'Self Employed',
                  icon: Icons.work,
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Self Employed')),
                    DropdownMenuItem(value: '0', child: Text('Not Self Employed')),
                  ],
                  onChanged: (newValue) => setState(() {
                    selfEmployed = newValue!;
                  }),
                ),
                SizedBox(height: 16),

                // Dropdown for Property Area
                _buildDropdownField(
                  value: propertyArea,
                  labelText: 'Property Area',
                  icon: Icons.location_city,
                  items: [
                    DropdownMenuItem(value: '0', child: Text('Rural')),
                    DropdownMenuItem(value: '1', child: Text('Semiurban')),
                    DropdownMenuItem(value: '2', child: Text('Urban')),
                  ],
                  onChanged: (newValue) => setState(() {
                    propertyArea = newValue!;
                  }),
                ),
                SizedBox(height: 16),

                // Button to trigger prediction
                ElevatedButton(
                  onPressed: _predictLoanStatus,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue, // Set button color to blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Predict Loan Approval',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),

                // Display loan status and probability
                if (result.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        'Loan Status: $result',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Approval Probability: $probability',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper to build input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.blueAccent), // Set icon color to blue
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  // Helper to build dropdown fields
  Widget _buildDropdownField({
    required String value,
    required String labelText,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.blueAccent), // Set icon color to blue
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}
