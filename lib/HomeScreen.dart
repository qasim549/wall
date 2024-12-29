import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/Tabs_Page/football.dart';
import 'package:wallpaper/Tabs_Page/hack_wallpaper.dart';
import 'package:wallpaper/Tabs_Page/music_wallpaper.dart';
import 'package:wallpaper/Tabs_Page/nature_wallpaper.dart';
import 'package:wallpaper/Tabs_Page/fourK_Page.dart';
import 'package:wallpaper/Tabs_Page/space_wallpaper.dart';
import 'package:wallpaper/Tabs_Page/travel_wallpaper.dart';

// Dummy pages for navigation
class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Add Wallpapers", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Your Profile", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0; // For bottom navigation bar state
  int _selectedIndex = 0; // To handle category switching
  TextEditingController _searchController = TextEditingController();
  List<String> tabs = [
    "Islamic",
    "Space",
    "Nature",
    "Travel",
    "Football",
    "Hack",
    "Music"
  ];
  List<Widget> tabWidgets = [
    const FourKPage(),
    const Space(),
    const nature(),
    const travelPage(),
    const football(),
    const hackPage(),
    const musicPage(),
  ];
  List<String> filteredTabs = []; // To store the filtered tabs based on search input

  final Connectivity _connectivity = Connectivity();

  // Pages for the bottom navigation
  final List<Widget> bottomNavPages = [
    HomeContent(), // Updated to use a proper widget
    AddPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    filteredTabs = tabs; // Initially show all tabs
    _checkConnection();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty) {
        _updateConnectionStatus(result.first);
      }
    });
  }

  Future<void> _checkConnection() async {
    ConnectivityResult result =
    (await _connectivity.checkConnectivity()) as ConnectivityResult;
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Oops! You are currently offline. Please check your connection.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 6),
          showCloseIcon: true,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Great! You are back online.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shadowColor: Colors.white,
        title: const Text(
          'Exit App',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to exit the app?',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white60),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.white60,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    )) ??
        false;
  }

  // Function to handle search
  void _search(String query) {
    setState(() {
      filteredTabs = tabs
          .where((tab) => tab.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (filteredTabs.isEmpty) {
        // If no match found, show a default screen or message
        filteredTabs = tabs; // Or you can navigate to a "no results" page
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitConfirmationDialog,
      child: Scaffold(
        body: bottomNavPages[_bottomNavIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _bottomNavIndex,
          onTap: (int index) {
            setState(() {
              _bottomNavIndex = index; // Update index to navigate
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Wallpapers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// Home Content widget with dynamic category switching based on search
class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _selectedIndex = 0;
  TextEditingController _searchController = TextEditingController();
  List<String> tabs = [
    "Islamic",
    "Space",
    "Nature",
    "Travel",
    "Football",
    "Hack",
    "Music"
  ];

  List<Widget> tabWidgets = [
    const FourKPage(),
    const Space(),
    const nature(),
    const travelPage(),
    const football(),
    const hackPage(),
    const musicPage(),
  ];

  List<String> filteredTabs = [];

  @override
  void initState() {
    super.initState();
    filteredTabs = tabs; // Initially show all tabs
  }

  void _search(String query) {
    setState(() {
      filteredTabs = tabs
          .where((tab) => tab.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: AnimSearchBar(
              width: 300,
              textController: _searchController,
              onSuffixTap: () {
                _searchController.clear();
                _search('');
              },
              onSubmitted: _search,
              helpText: 'Search Categories...',
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            color: Colors.black,
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredTabs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _selectedIndex == index
                              ? Colors.white
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      filteredTabs[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _selectedIndex == index
                            ? Colors.white
                            : Colors.white70,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: tabWidgets[_selectedIndex], // Display wallpapers here
          ),
        ],
      ),
    );
  }
}
