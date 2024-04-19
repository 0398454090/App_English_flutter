import 'package:flutter/material.dart';

class FolderScreen extends StatelessWidget {
  const FolderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Folder", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg2.png',
            fit: BoxFit.cover,
          ),
          ListView(
            children: [
              _buildFolder1(color: Color.fromARGB(255, 207, 68, 225)),
              _buildFolder2(color: Color.fromARGB(255, 1, 57, 103)),
              _buildFolder3(color: const Color.fromARGB(255, 38, 140, 42)),
              _buildFolder4(color: Color.fromARGB(255, 241, 174, 75)),
              _buildFolder5(color: Color.fromARGB(255, 75, 202, 241)),
              _buildFolder6(color: Colors.red),
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
            'Travel and Tourism',
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
            'Education',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          Container(
            width: 150,
            height: 90,
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
            'Holiday and culture',
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
            'Holiday and culture',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolder6({required Color color}) {
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
            'Holiday and culture',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
