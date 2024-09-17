import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import firebase_core
import 'Faqs.dart';
import 'settings.dart';
import 'login.dart';  // Import login page
import 'signup.dart'; // Import signup page
import 'home.dart';   // Import home page
import 'loan.dart';   // Import predict page
import 'report.dart';  // Import about us page
import 'loan_details.dart'; // Import loan details page
import 'reset_pwd.dart';
import 'reset_confirmation.dart';
import 'user_profile.dart';
import 'add_customer.dart';
import 'customer_records.dart';  // Import customer records page
import 'manage_loans.dart';
import 'profile_settings.dart';
import 'history.dart';  // Ensure this is imported correctly
import 'splash.dart';


// Define Firebase options for web (Replace with your actual Firebase values)
const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyBBOyOhOsM4u98oCVuNQMKRjsaKZvMYFrw",  // Replace with your API key from Firebase console
  authDomain: "your-auth-domain",      // Replace with your authDomain from Firebase console
  projectId: "loangenuisapp-18fcf",    // Replace with your projectId from Firebase console
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',  // Default route
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/predict': (context) => PredictScreen(),
        '/report': (context) => ReportsScreen(),
        '/loanDetails': (context) => LoanDetailsScreen(),
        '/reset_pwd': (context) => ResetPasswordScreen(),
        '/reset_confirmation': (context) => ResetConfirmationScreen(),
        '/user_profile': (context) => UserProfileScreen(),
        '/add_customer': (context) => AddCustomerScreen(),
        '/customer_records': (context) => CustomerRecordsScreen(),
        '/manage_loans': (context) => ManageLoansScreen(),
        '/settings': (context) => SettingsScreen(),
        '/profile_settings': (context) => ProfileSettingsScreen(),
        '/faqs': (context) => FAQScreen(),
        '/history': (context) => HistoryPage(),  // Corrected history route
        '/splash': (context) => MySplashScreen(),

      },
    );
  }
}
