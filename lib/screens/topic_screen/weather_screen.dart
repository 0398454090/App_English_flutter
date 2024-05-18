import 'package:app_english/screens/topic_screen/Quiz_screen/quiz_screen.dart';
import 'package:app_english/screens/topic_screen/flashcard_screen/flashcard_screen.dart';
import 'package:app_english/screens/topic_screen/type_screen/type_screen.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  // Danh sách các chủ đề và biểu tượng tương ứng
  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Weather',
      'icon': Icons.cloud,
      'iconColor': Colors.grey,
      'rectColor': Colors.white
    },
    {
      'title': 'Lifestyle',
      'icon': Icons.travel_explore,
      'iconColor': Colors.blue[900],
      'rectColor': Colors.white
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather and Travel'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Ôn tập hằng ngày',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          // Hiển thị mục yêu thích của thế giới ở đây
          Container(
            padding: const EdgeInsets.all(16),
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/HI.png',
                  width: 160,
                  height: 160,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          // Hiển thị mục yêu thích của thế giới ở đây
          Expanded(
            child: ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                return InkWell(
                  onTap: () {
                    print('Selected topic: ${topic['title']}');
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: topic['rectColor'],
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          topic['icon'],
                          color: topic['iconColor'],
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          topic['title'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'FlashCard',
                              child: Text('FlashCard'),
                            ),
                            const PopupMenuItem(
                              value: 'Quiz',
                              child: Text('Quiz'),
                            ),
                            const PopupMenuItem(
                              value: 'Type',
                              child: Text('Type'),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'FlashCard') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlashCardScreen(),
                                ),
                              );
                            } else if (value == 'Quiz') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QuizScreen(), // Thay QuizScreen bằng tên lớp của màn hình Quiz
                                ),
                              );
                            } else if (value == 'Type') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TypeScreen(), // Thay TypeScreen bằng tên lớp của màn hình Type
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
