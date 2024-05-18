import 'package:app_english/screens/main_page/settings/screens/folder/user_folder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Import UserFolderScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Hàm xử lý chuyển hướng đến UserFolderScreen
  void _handleFlashcards(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const UserFolderScreen()), // Chuyển hướng đến UserFolderScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD7E1EC), // Màu nền trong suốt
        systemOverlayStyle: SystemUiOverlayStyle.dark, // Văn bản màu tối
        title: const Text("Home"), // Tiêu đề của app bar
        centerTitle: true, // Căn giữa tiêu đề
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFD7E1EC),
              Color(0xFFFCFDF6),
              Color(0xFFD7E1EC),
            ],
            begin: Alignment.topCenter, // Điểm bắt đầu của gradient
            end: Alignment.bottomCenter, // Điểm kết thúc của gradient
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 5),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Let's ", style: TextStyle(color: Colors.red)),
                      TextSpan(
                          text: 'learn ',
                          style: TextStyle(color: Colors.purple)),
                      TextSpan(
                          text: 'English ',
                          style: TextStyle(color: Colors.green)),
                      TextSpan(
                          text: 'together',
                          style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
                GestureDetector(
                  // Sử dụng GestureDetector để xử lý sự kiện nhấn
                  onTap: () {
                    _handleFlashcards(context); // Gọi hàm để chuyển hướng
                  },
                  child: Image.asset(
                    'assets/images/search_here.png',
                    width: double.infinity,
                    height: 80,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Today\'s Lesson',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/flashcard_logo.png'),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        stops: const [0.3, 0.9],
                        colors: [
                          Colors.black.withOpacity(.4),
                          Colors.black.withOpacity(.1),
                        ],
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Flashcards',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/quiz_logo.png'),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        stops: const [0.3, 0.9],
                        colors: [
                          Colors.black.withOpacity(.4),
                          Colors.black.withOpacity(.1),
                        ],
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Quiz Game',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/type_logo.png'),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        stops: const [0.3, 0.9],
                        colors: [
                          Colors.black.withOpacity(.4),
                          Colors.black.withOpacity(.1),
                        ],
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Typing Practice',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
