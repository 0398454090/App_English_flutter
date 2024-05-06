import 'package:flutter/material.dart';

class FolderScreen extends StatelessWidget {
  const FolderScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Folder", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF020E22),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFF020E22),
        child: ListView(
          children: [
            _buildFolder(
              title: 'Food and Beverage',
              image: 'assets/images/food_logo.png',
              color: const Color.fromARGB(255, 207, 68, 225),
            ),
            _buildFolder(
              image: 'assets/images/travel_logo.png',
              color: const Color.fromARGB(255, 1, 57, 103),
              title: 'Weather and Travel',
            ),
            _buildFolder(
              title: 'Education and Technology',
              image: 'assets/images/edu_logo.png',
              color: const Color.fromARGB(255, 38, 140, 42),
            ),
            _buildFolder(
              image: 'assets/images/holiday_logo.png',
              color: const Color.fromARGB(255, 0, 132, 247),
              title: 'Countries and Cultures',
            ),
            _buildFolder(
              title: 'Health and Lifestyle',
              image: 'assets/images/health_logo.png',
              color: const Color.fromARGB(255, 3, 105, 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolder({
    required String title,
    required String image,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            height: 120,
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
