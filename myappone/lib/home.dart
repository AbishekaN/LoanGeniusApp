import 'package:flutter/material.dart';
import 'package:myappone/user_profile.dart'; // Import the UserProfileScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName = "John Doe"; // Replace with dynamic username if needed
  int _currentIndex = 0;

  // List of pages for bottom navigation bar
  final List<Widget> _pages = [
    HomePageContent(),
    HistoryPage(),
    MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfileScreen()), // Navigate to UserProfileScreen
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/user_icon.png'), // User icon here
              ),
              SizedBox(width: 8),
              Text(
                userName,
                style: TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis, // Handles overflow
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings'); // Navigate to Settings screen
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: _pages[_currentIndex], // Load the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update index when a tab is clicked
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

// Home page content (new UI with GridView for catalog)
class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 100,
            color: Colors.blue[100], // Light blue background for welcome banner
            child: Center(
              child: Text(
                'Welcome G A P',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Catalog', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              CategoryCard(
                icon: Icons.person_add,
                label: 'Add Customer',
                onTap: () {
                  Navigator.pushNamed(context, '/addCustomer'); // Navigate to Add Customer screen
                },
              ),
              CategoryCard(
                icon: Icons.people,
                label: 'Customer Records',
                onTap: () {
                  Navigator.pushNamed(context, '/customerRecords'); // Navigate to Customer Records screen
                },
              ),
              CategoryCard(
                icon: Icons.credit_card,
                label: 'Manage Loans',
                onTap: () {
                  Navigator.pushNamed(context, '/manageLoans'); // Navigate to Manage Loans screen
                },
              ),
              CategoryCard(
                icon: Icons.check_circle_outline,
                label: 'Loan Eligibility',
                onTap: () {
                  Navigator.pushNamed(context, '/predict'); // Navigate to Loan Eligibility (Prediction) screen
                },
              ),
              CategoryCard(
                icon: Icons.analytics,
                label: 'Reports',
                onTap: () {
                  Navigator.pushNamed(context, '/reports'); // Navigate to Reports screen
                },
              ),
              CategoryCard(
                icon: Icons.new_releases,
                label: 'New',
                onTap: () {
                  Navigator.pushNamed(context, '/newFeature'); // Navigate to New Feature screen
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Category Card Widget (For Catalog Grid Items)
class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  CategoryCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// History page
class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'History Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// More page (Placeholder for more options)
class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'More Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
