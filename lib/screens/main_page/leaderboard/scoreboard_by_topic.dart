import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ScoreboardScreen extends StatefulWidget {
  final String topicId;
  final String topicName;
  const ScoreboardScreen(
      {Key? key, required this.topicId, required this.topicName})
      : super(key: key);

  @override
  _ScoreboardScreenState createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  bool isLoading = true;
  List<dynamic> quizData = [];
  List<dynamic> multipleChoiceData = [];
  bool showMultipleChoice = true;
  final String? URI = dotenv.env['PORT'];
  List<bool> isSelected = [
    true,
    false
  ]; // Track the selected state of the buttons

  @override
  void initState() {
    super.initState();
    _fetchScoreboard();
  }

  Future<void> _fetchScoreboard() async {
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final response = await http
        .get(Uri.parse('$URI/test/get-topic-scoreboard/${widget.topicId}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        for (var item in data) {
          if (item['category'] == 'Quiz') {
            quizData = item['tests'];
          } else if (item['category'] == 'Multiple Choice Quiz') {
            multipleChoiceData = item['tests'];
          }
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load scoreboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD7E1EC),
        title: Text('Scoreboard: ${widget.topicName}'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(10.0),
                    isSelected: isSelected,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                        }
                        showMultipleChoice = index == 0;
                      });
                    },
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Multiple Choice'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Quiz'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: showMultipleChoice
                        ? multipleChoiceData.length
                        : quizData.length,
                    itemBuilder: (context, index) {
                      final test = showMultipleChoice
                          ? multipleChoiceData[index]
                          : quizData[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getColorByIndex(index),
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(test['userFullName'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Correct Results: ${test['correctResult'] ?? 'N/A'}',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6))),
                              Text(
                                  'Time Completed: ${test['timeCompleted'] ?? 'N/A'}',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6))),
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

  Color _getColorByIndex(int index) {
    if (index == 0) {
      return Colors.amber;
    } else if (index == 1) {
      return Colors.grey;
    } else if (index == 2) {
      return Colors.green;
    } else if (index == 1) {
      return Colors.purple;
    } else if (index == 2) {
      return Colors.lime;
    } else if (index == 1) {
      return Colors.redAccent;
    } else if (index == 2) {
      return Colors.brown;
    } else {
      return Colors.blue;
    }
  }
}

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scoreboard App',
      theme: ThemeData(
        primaryColorDark: Color(0xFFFCFDF6),
      ),
      home: ScoreboardScreen(topicId: '1', topicName: 'Sample Topic'),
    );
  }
}
