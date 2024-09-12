import 'package:flutter/material.dart';
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

        // Debug: Print the result to the console
        print('API Result: $apiResult');

        // Update the UI with the result and probability
        setState(() {
          result = apiResult['loan_status'];

          // Option 1: Show probability as decimal (0.58)
          probability = double.parse(apiResult['probability'].toString())
              .toStringAsFixed(2);

          // Option 2: Show probability as percentage (58%)
          // probability = (double.parse(apiResult['probability'].toString()) * 100).toStringAsFixed(2) + '%';
        });
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
      appBar: AppBar(title: Text('Loan Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Input fields
                TextFormField(
                  controller: applicantIncomeController,
                  decoration: InputDecoration(labelText: 'Applicant Income'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter applicant income';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: coapplicantIncomeController,
                  decoration: InputDecoration(labelText: 'Coapplicant Income'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter coapplicant income';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: loanAmountController,
                  decoration: InputDecoration(labelText: 'Loan Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter loan amount';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: loanTermController,
                  decoration: InputDecoration(labelText: 'Loan Term (days)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter loan term';
                    }
                    return null;
                  },
                ),

                // Dropdown for Credit History
                DropdownButtonFormField<String>(
                  value: creditHistory,
                  onChanged: (newValue) {
                    setState(() {
                      creditHistory = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Has Credit History')),
                    DropdownMenuItem(value: '0', child: Text('No Credit History')),
                  ],
                  decoration: InputDecoration(labelText: 'Credit History'),
                ),

                // Dropdown for Gender
                DropdownButtonFormField<String>(
                  value: gender,
                  onChanged: (newValue) {
                    setState(() {
                      gender = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Male')),
                    DropdownMenuItem(value: '0', child: Text('Female')),
                  ],
                  decoration: InputDecoration(labelText: 'Gender'),
                ),

                // Dropdown for Married
                DropdownButtonFormField<String>(
                  value: married,
                  onChanged: (newValue) {
                    setState(() {
                      married = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Married')),
                    DropdownMenuItem(value: '0', child: Text('Not Married')),
                  ],
                  decoration: InputDecoration(labelText: 'Marital Status'),
                ),

                // Dropdown for Dependents
                DropdownButtonFormField<String>(
                  value: dependents,
                  onChanged: (newValue) {
                    setState(() {
                      dependents = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: '0', child: Text('0')),
                    DropdownMenuItem(value: '1', child: Text('1')),
                    DropdownMenuItem(value: '2', child: Text('2')),
                    DropdownMenuItem(value: '3+', child: Text('3+')),
                  ],
                  decoration: InputDecoration(labelText: 'Dependents'),
                ),

                // Dropdown for Education
                DropdownButtonFormField<String>(
                  value: education,
                  onChanged: (newValue) {
                    setState(() {
                      education = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Graduate')),
                    DropdownMenuItem(value: '0', child: Text('Not Graduate')),
                  ],
                  decoration: InputDecoration(labelText: 'Education'),
                ),

                // Dropdown for Self-Employed
                DropdownButtonFormField<String>(
                  value: selfEmployed,
                  onChanged: (newValue) {
                    setState(() {
                      selfEmployed = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Self Employed')),
                    DropdownMenuItem(value: '0', child: Text('Not Self Employed')),
                  ],
                  decoration: InputDecoration(labelText: 'Self Employed'),
                ),

                // Dropdown for Property Area
                DropdownButtonFormField<String>(
                  value: propertyArea,
                  onChanged: (newValue) {
                    setState(() {
                      propertyArea = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: '0', child: Text('Rural')),
                    DropdownMenuItem(value: '1', child: Text('Semiurban')),
                    DropdownMenuItem(value: '2', child: Text('Urban')),
                  ],
                  decoration: InputDecoration(labelText: 'Property Area'),
                ),

                // Button to trigger prediction
                ElevatedButton(
                  onPressed: _predictLoanStatus,
                  child: Text('Predict Loan Approval'),
                ),
                SizedBox(height: 20),

                // Display loan status and probability
                Text(
                  'Loan Status: $result',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Approval Probability: $probability',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}