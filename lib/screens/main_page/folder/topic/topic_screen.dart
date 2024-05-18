import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import '../../../topic_screen/Quiz_screen/quiz_screen.dart';
import '../../../topic_screen/flashcard_screen/flashcard_screen.dart';
import '../../../topic_screen/type_screen/type_screen.dart';

class TopicScreen extends StatefulWidget {
  final String folderId;

  const TopicScreen({Key? key, required this.folderId}) : super(key: key);

  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> topics = [];

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  Future<void> _fetchTopics() async {
    final String? URI = dotenv.env['PORT'];
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final response =
        await http.get(Uri.parse('$URI/topic/get/${widget.folderId}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        topics = data
            .where((item) => item['public'] == true)
            .map((item) => {
                  'id': item['id'],
                  'title': item['name'],
                  'wordIdCount':
                      item['wordId'] != null ? item['wordId'].length : 0,
                  'rectColor': Colors.white,
                })
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load topics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Topics',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFCFDF6), Color(0xFFD7E1EC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  topic['title'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
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
                                    if (topic['wordIdCount'] > 10)
                                      const PopupMenuItem(
                                        value: 'Quiz',
                                        child: Text('Quiz'),
                                      ),
                                    if (topic['wordIdCount'] > 10)
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
                                          builder: (context) => FlashCardScreen(
                                              topicId: topic['id']),
                                        ),
                                      );
                                    } else if (value == 'Quiz') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              QuizScreen(topicId: topic['id']),
                                        ),
                                      );
                                    } else if (value == 'Type') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TypeScreen(topicId: topic['id']),
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
      ),
    );
  }
}
