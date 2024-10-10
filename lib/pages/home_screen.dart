import 'package:flutter/material.dart';
import 'account_page.dart';
import 'bounty_page.dart';
import 'upload_page.dart';
import 'image_feed_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Titles corresponding to each page in the bottom navigation bar
  final List<String> _pageTitles = [
    'Image Feed',
    'Account',
    'Bounty',
    'Upload'
  ];

  // List of the pages for the bottom navigation
  final List<Widget> _pages = [
    const ImageFeedPage(),
    const AccountPage(),
    const BountyPage(),
    const UploadPage(),
  ];

  // Update the selected index when an item is tapped
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Ensure no back button is shown
        title: Text(_pageTitles[_selectedIndex]), // Set dynamic title based on page
      ),
      body: _pages[_selectedIndex], // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Bounty',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
