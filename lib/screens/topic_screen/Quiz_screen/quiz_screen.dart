import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  final String topicId;

  const QuizScreen({Key? key, required this.topicId}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = true;
  bool _isAnswering = false;
  String? _selectedAnswer;
  String? _feedbackMessage;
  Color _feedbackColor = Colors.transparent;
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
  }

  Future<void> _fetchQuizData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');
    final String? uri = dotenv.env['PORT'];

    if (uri == null || userId == null) {
      throw Exception('API URI or User ID not found in environment variables.');
    }

    final response = await http.post(
      Uri.parse('$uri/test/start-mcq-test'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'topicId': widget.topicId,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _questions = data['questions'];
        _isLoading = false;
      });
      _startTimer();
    } else {
      throw Exception('Failed to load quiz data');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime = _elapsedTime + Duration(seconds: 1);
      });
    });
  }

  Future<void> _checkAnswer() async {
    setState(() {
      _isAnswering = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');
    final String? uri = dotenv.env['PORT'];

    if (uri == null || userId == null) {
      throw Exception('API URI or User ID not found in environment variables.');
    }

    final question = _questions[_currentQuestionIndex];
    final response = await http.post(
      Uri.parse('$uri/question/check-mcq-result'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'testId': question['testId'],
        'questionId': question['id'],
        'answer': _selectedAnswer,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      final bool isCorrect = json.decode(response.body);
      setState(() {
        _feedbackMessage = isCorrect ? 'Correct!' : 'Incorrect!';
        _feedbackColor = isCorrect ? Colors.green : Colors.red;
        _isAnswering = false;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _feedbackMessage = null;
          _feedbackColor = Colors.transparent;
          _nextQuestion();
        });
      });
    } else {
      setState(() {
        _isAnswering = false;
      });
      throw Exception('Failed to check answer');
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      });
    } else {
      _timer?.cancel(); // Pause the timer when quiz is completed
      // Show dialog with correct answer and time completed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Completed'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Correct Answer: ${_questions[_currentQuestionIndex]['correctAnswer']}'),
                SizedBox(height: 10),
                Text('Time Completed: ${_elapsedTime.inSeconds} seconds'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _completeQuizTest(); // Call API to complete quiz test
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Return to the main page
                },
                child: Text('Complete'),
              ),
            ],
          );
        },
      );
    }
  }

  void _completeQuizTest() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uri = dotenv.env['PORT'];
    final userId = prefs.getString('id');
    final testId = _questions
        .first['testId']; // Assuming testId is the same for all questions

    if (uri == null || userId == null) {
      throw Exception('API URI or User ID not found in environment variables.');
    }

    final response = await http.post(
      Uri.parse('$uri/test/complete-mcq-test'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'testId': testId,
        'timeTaken': _elapsedTime.inSeconds,
      }),
    );

    if (response.statusCode == 200) {
      // Quiz test completed successfully
    } else {
      throw Exception('Failed to complete quiz test');
    }
  }

  Widget _buildTimer() {
    return Text(
      'Time: ${_elapsedTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
      '${(_elapsedTime.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
      style: TextStyle(fontSize: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimer(),
            SizedBox(height: 20),
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              question['question'],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ...question['options'].map<Widget>((option) {
              return ListTile(
                title: Text(option),
                leading: Radio<String>(
                  value: option,
                  groupValue: _selectedAnswer,
                  onChanged: _isAnswering
                      ? null
                      : (value) {
                          setState(() {
                            _selectedAnswer = value;
                          });
                        },
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            if (_feedbackMessage != null)
              Text(
                _feedbackMessage!,
                style: TextStyle(fontSize: 18, color: _feedbackColor),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedAnswer == null || _isAnswering
                  ? null
                  : () {
                      _checkAnswer();
                    },
              child: Text(_currentQuestionIndex < _questions.length - 1
                  ? 'Next'
                  : 'Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
