import 'package:app_english/screens/main_page/folder_screen.dart';
import 'package:app_english/screens/main_page/home_screen.dart';
import 'package:app_english/screens/main_page/leaderboard_screen.dart';
import 'package:app_english/screens/main_page/search_screen.dart';
import 'package:app_english/screens/main_page/settings/screens/setting_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage>{
  int index = 2;
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.search, size: 30,),
      const Icon(Icons.folder, size: 30,),
      const Icon(Icons.home, size: 30,),
      const Icon(Icons.leaderboard, size: 30,),
      const Icon(Icons.settings, size: 30,)
    ];

    final screens = [
      const SearchScreen(),
      const FolderScreen(),
      const HomeScreen(),
      const LeaderboardScreen(),
      const SettingScreen(),
    ];

    return Container(
      color: Colors.white,
      child: SafeArea(
          top: false,
          child: ClipRect(child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.cyan,
            body: screens[index],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              child: CurvedNavigationBar(
                color: Colors.black,
                buttonBackgroundColor: Colors.black,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                height: 50,
                index: index,
                items: items,
                onTap: (index) => setState(() {
                  this.index = index;
                }),
              ),
            )
          ),
          ),
      ),
    );
  }

}