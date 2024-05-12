import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:app_english/screens/main_page/folder_screen.dart';
import 'package:app_english/screens/main_page/home_screen.dart';
import 'package:app_english/screens/main_page/leaderboard_screen.dart';
import 'package:app_english/screens/main_page/search_screen.dart';
import 'package:app_english/screens/main_page/settings/screens/setting_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const SearchScreen(),
      const FolderScreen(),
      const HomeScreen(),
      const LeaderboardScreen(),
      const SettingScreen(),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFDAE4CD), // Đặt màu nền cho Scaffold
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Màu shadow
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.search),
              title: Text('Search'),
              selectedColor: Colors.blue[400],
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.folder),
              title: Text('Folder'),
              selectedColor: Colors.blue[400],
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              selectedColor: Colors.blue[400],
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.leaderboard),
              title: Text('Leaderboard'),
              selectedColor: Colors.blue[400],
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
              selectedColor: Colors.blue[400],
            ),
          ],
        ),
      ),
    );
  }
}
