import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import firebase_core
import 'login.dart';  // Import login page
import 'signup.dart'; // Import signup page
import 'home.dart';   // Import home page
import 'loan.dart';   // Import predict page
import 'about.dart';  // Import about us page
import 'services.dart'; // Import services page
import 'loan_details.dart'; // Import loan details page
import 'reset_pwd.dart';
import 'reset_confirmation.dart';

// Define Firebase options for web (Replace with your actual Firebase values)
const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyBBOyOhOsM4u98oCVuNQMKRjsaKZvMYFrw",             // Replace with your API key from Firebase console
  authDomain: "your-auth-domain",      // Replace with your authDomain from Firebase console
  projectId: "loangenuisapp-18fcf",        // Replace with your projectId from Firebase console
  storageBucket: "your-storage-bucket", // Replace with your storageBucket from Firebase console
  messagingSenderId: "your-messaging-sender-id",  // Replace with your messagingSenderId from Firebase console
  appId: "your-app-id",                // Replace with your appId from Firebase console
  measurementId: "your-measurement-id", // Replace with your measurementId if needed
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure all binding is initialized

  // Initialize Firebase with specific options for web
  await Firebase.initializeApp(
    options: firebaseOptions,  // Initialize Firebase with your project-specific options
  );

  runApp(LoanPredictionApp());  // Your main app
}

class LoanPredictionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/signup',  // Default route
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/predict': (context) => PredictScreen(),
        '/about': (context) => AboutScreen(),
        '/services': (context) => ServicesScreen(),
        '/loanDetails': (context) => LoanDetailsScreen(),
        '/reset_pwd': (context) => ResetPasswordScreen(),
        '/reset_confirmation': (context) => ResetConfirmationScreen(),// Ensure this route exists

      },
    );
  }
}
