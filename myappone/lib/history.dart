import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';  // Add this import for date formatting

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Variable to hold fetched loan history
  List<Map<String, dynamic>> loanHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchLoanHistory(); // Call to fetch data when the page loads
  }

  // Function to fetch loan history from Firestore
  Future<void> _fetchLoanHistory() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('loanHistory')
            .where('userId', isEqualTo: user.uid)
            .get();
        List<Map<String, dynamic>> fetchedHistory = snapshot.docs.map((doc) {
          return {
            'status': doc['status'],
            'date': doc['date'],
          };
        }).toList();

        // Update the loan history in the UI
        setState(() {
          loanHistory = fetchedHistory;
        });
      }
    } catch (e) {
      print('Error fetching loan history: $e');
    }
  }

  // Function to convert Firestore timestamp to local time and format it
  String formatDateTime(String timestamp) {
    DateTime utcDateTime = DateTime.parse(timestamp); // Parse the timestamp
    DateTime localDateTime = utcDateTime.toLocal(); // Convert to local time
    return DateFormat('yyyy-MM-dd HH:mm').format(localDateTime); // Format date and time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan History'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: loanHistory.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator while fetching data
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: loanHistory.length,
          itemBuilder: (context, index) {
            final historyItem = loanHistory[index];
            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    historyItem['status'] == 'Approved'
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    color: historyItem['status'] == 'Approved'
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(
                    historyItem['status'] == 'Approved'
                        ? 'Loan Approved'
                        : 'Loan Rejected',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text('Status: ${historyItem['status']}'),
                  trailing: Text(formatDateTime(historyItem['date'])),
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  } 
}
