import 'package:flutter/material.dart';

class CultureScreen extends StatelessWidget {
  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Culture',
      'imagePath':
          'assets/images/culture_icon.png', // Thêm đường dẫn đến hình ảnh

      'rectColor': Colors.white
    },
    {
      'title': 'Countries',
      'imagePath': 'assets/images/countries.png',
      'rectColor': Colors.white
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Culture'),
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
          // Hiển thị hình ảnh
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
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Sử dụng hình ảnh thay vì Icon
                        Image.asset(
                          topic['imagePath'],
                          width: 48,
                          height: 48,
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
                            print('Selected option: $value');
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
