import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/predict'),
              child: Text('Predict Loan Eligibility'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/about'),
              child: Text('About Us'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/services'),
              child: Text('Services'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/loanDetails'),
              child: Text('Loan Details'),
            ),
          ],
        ),
      ),
    );
  }
}
