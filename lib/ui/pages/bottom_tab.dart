import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:siapel_mobile/ui/pages/main_page.dart';
import 'package:siapel_mobile/ui/pages/account_screen.dart';
import 'package:siapel_mobile/ui/pages/status_document.dart';
import '../../shared/theme.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomkTab extends StatefulWidget {
  const BottomkTab({Key? key}) : super(key: key);

  @override
  State<BottomkTab> createState() => _BottomkTabState();
}

class _BottomkTabState extends State<BottomkTab> {
  int _currentIndex = 0;
  late PageController _pageController;
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    print(token);
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List _children = [
    MainPage(),
    StatusDocument(),
    AccountScreen(),
  ];

  final List _children2 = [
    MainPage(),
    StatusDocument(),
    AccountScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My Flutter App'),
      // ),
      body: isAuth ? _children[_currentIndex] : _children2[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        //mainAxisAlignment: MainAxisAlignment.center,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: kPrimaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.info),
            title: Text(
              'Status Dokumen',
            ),
            activeColor: kPrimaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.people),
            title: Text(
              'Profil',
            ),
            activeColor: Color(
                0xFF001F3F), // Warna biru tua (dark blue) dengan nilai RGB
            textAlign: TextAlign.center,
          ),
        ],
      ),
      // BottomNavigationBar(
      //   onTap: onTabTapped,
      //   // new
      //   currentIndex: _currentIndex,
      //   selectedLabelStyle: TextStyle(fontSize: 18),
      //   selectedItemColor:
      //       kPrimaryColor, // this will be set when a new tab is tapped
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: new Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: new Icon(Icons.mail),
      //       label: "Status",
      //     ),
      //   ],
      // ),
    );
  }
}
