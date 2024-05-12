import 'package:flutter/material.dart';

class FolderScreen extends StatelessWidget {
  const FolderScreen({super.key});

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: const Color(0xFF020E22),
          ),
          ListView(
            children: [
              _buildFolder1(color: const Color.fromARGB(255, 207, 68, 225)),
              _buildFolder2(color: const Color.fromARGB(255, 1, 57, 103)),
              _buildFolder3(color: const Color.fromARGB(255, 38, 140, 42)),
              _buildFolder4(color: const Color.fromARGB(255, 0, 132, 247)),
              _buildFolder5(color: const Color.fromARGB(255, 3, 105, 100)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFolder1({required Color color}) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Food and Beverage',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          Container(
            width: 100,
            height: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/food_logo.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolder2({required Color color}) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 110,
            height: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/travel_logo.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const Text(
            'Weather and Travel',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolder3({required Color color}) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Education and',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          Container(
            width: 120,
            height: 80,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/edu_logo.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolder4({required Color color}) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 80,
            height: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/holiday_logo.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const Text(
            'Countries and Cultures',
            //toppic no se co: City - Restaurant - Cuisine - Local Culture - Local Language.
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolder5({required Color color}) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Health and Lifestyle',
            //Nutrition", "Exercise", "Psychology", "Modern Medicine", and "Eastern Medicine".
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          Container(
            width: 150,
            height: 80,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/health_logo.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
