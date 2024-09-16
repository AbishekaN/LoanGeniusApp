import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I add a customer?',
      'answer': 'You can add a customer by clicking on the "Add Customer" button on the home screen.'
    },
    {
      'question': 'How do I manage loans?',
      'answer': 'Go to the "Manage Loans" section and you can add, edit, or delete loans for customers.'
    },
    {
      'question': 'What is the loan eligibility feature?',
      'answer': 'The loan eligibility feature predicts if a customer is eligible for a loan based on their details.'
    },
    {
      'question': 'How can I reset my password?',
      'answer': 'You can reset your password by going to the Privacy & Security settings and selecting "Change Password".'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqs[index]['question'] ?? '',
                style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(faqs[index]['answer'] ?? ''),
              )
            ],
          );
        },
      ),
    );
  }
}
