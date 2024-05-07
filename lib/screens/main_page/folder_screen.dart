import 'package:flutter/material.dart';

import '../topic_screen/food_screen.dart';
import '../topic_screen/culture_screen.dart';
import '../topic_screen/weather_screen.dart';
import '../topic_screen/health_screen.dart';
import '../topic_screen/education_screen.dart';

class FolderScreen extends StatelessWidget {
  const FolderScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFDFE4DA),
        title: const Text("Folder",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            )),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFDFE4DA),
        child: ListView(
          children: [
            _buildFolder(
              context,
              title: 'Food and Beverage',
              image: 'assets/images/food_logo.png',
              color: Color.fromARGB(255, 129, 4, 145),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodScreen()),
                );
              },
            ),
            _buildFolder(
              context,
              image: 'assets/images/travel_logo.png',
              color: Color.fromARGB(255, 10, 67, 114),
              title: 'Weather and Travel',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherScreen()),
                );
              },
            ),
            _buildFolder(
              context,
              title: 'Education and Technology',
              image: 'assets/images/edu_logo.png',
              color: Color.fromARGB(255, 14, 105, 17),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EducationScreen()),
                );
              },
            ),
            _buildFolder(
              context,
              image: 'assets/images/holiday_logo.png',
              color: Color.fromARGB(255, 8, 50, 87),
              title: 'Countries and Cultures',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CultureScreen()),
                );
              },
            ),
            _buildFolder(
              context,
              title: 'Health and Lifestyle',
              image: 'assets/images/health_logo.png',
              color: Color.fromARGB(255, 5, 75, 71),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HealthScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolder(
    BuildContext context, {
    required String title,
    required String image,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              height: 100,
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
