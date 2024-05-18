import 'package:app_english/screens/auth_screen/signin_screen.dart';
import 'package:app_english/screens/auth_screen/signup_screen.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const WelcomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Lottie Animation
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset("assets/lottie/english.json"),
                const SizedBox(height: 200)
              ],
            ),
          ),
          // Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size(335,20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Change border radius of the button
                      ),
                      elevation: 0,
                      backgroundColor: Colors.blueAccent,),
                    child: const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size(335,20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Change border radius of the button
                      ),
                      elevation: 0,
                      backgroundColor: Colors.blueAccent,),
                    child: const Text('Sign up',  style: TextStyle(fontSize: 16, color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}