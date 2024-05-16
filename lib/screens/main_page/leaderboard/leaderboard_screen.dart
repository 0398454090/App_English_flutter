import 'package:app_english/screens/main_page/leaderboard/scoreboard_by_topic.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './model/topic_model.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  Future<List<Topic>> fetchTopics() async {
    final URI = dotenv.env['PORT'];
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }

    final response = await http.get(Uri.parse('$URI/topic/get-all'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Topic.fromJson(item)).where((topic) => topic.isPublic).toList();
    } else {
      throw Exception('Failed to load topics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics'),
      ),
      body: FutureBuilder<List<Topic>>(
        future: fetchTopics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No topics available'));
          }

          final topics = snapshot.data!;

          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 3,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScoreboardScreen(
                            topicId: topic.id,
                            topicName: topic.name,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(10.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(6),
                      leading: Icon(
                        Icons.topic,
                        color: Colors.black38,
                        size: 40,
                      ),
                      title: Text(
                        topic.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
