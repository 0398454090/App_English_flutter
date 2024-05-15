import 'dart:convert';

import 'package:app_english/screens/auth_screen/welcome_screen.dart';
import 'package:app_english/screens/main_page/settings/screens/folder/user_folder_screen.dart';
import 'package:app_english/screens/main_page/settings/screens/trained%20words/trained_word_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../widget/forward_button.dart';
import '../widget/setting_item.dart';
import 'account_screen.dart';
import 'marked words/marked_word_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String fullName = '';
  String userId = '';
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id')!;
    final String? URI = dotenv.env['PORT'];
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final url = '$URI/user/get/$userId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final userData = json.decode(response.body)['user'];
      setState(() {
        fullName = userData['fullName'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch user data'),
        ),
      );
    }
  }

  Future<void> _signOut() async {
    // Show confirmation dialog
    final bool confirmSignOut = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Return true when confirmed
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Return false when canceled
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    // If confirmed, clear token
    if (confirmSignOut == true) {
      // Clear token in shared preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('id');

      // Navigate to welcome screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Image.asset("assets/images/appicon.png", width: 70, height: 70),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Developer",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    ForwardButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditAccountScreen(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.black38),
                ),
                child: Column(
                  children: [
                    SettingItem(
                      textColor: Colors.black,
                      title: "Folder",
                      icon: Ionicons.folder,
                      bgColor: Colors.orange.shade100,
                      iconColor: Colors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserFolderScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 0),
                    SettingItem(
                      textColor: Colors.black,
                      title: "Marked Word",
                      icon: Ionicons.checkmark_outline,
                      bgColor: Colors.blue.shade100,
                      iconColor: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MarkedWordScreen(userId: userId),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 0),
                    SettingItem(
                      textColor: Colors.black,
                      title: "Trained Word",
                      icon: Ionicons.layers_outline,
                      bgColor: Colors.green.shade100,
                      iconColor: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainedWordScreen(userId: userId),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 0),
                    SettingItem(
                      textColor: Colors.red,
                      title: "Sign out",
                      icon: Ionicons.nuclear,
                      bgColor: Colors.red.shade100,
                      iconColor: Colors.red,
                      onTap: _signOut,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
