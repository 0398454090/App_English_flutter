import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TypeScreen extends StatefulWidget {
  final String topicId;

  const TypeScreen({Key? key, required this.topicId}) : super(key: key);

  @override
  _TypeScreenState createState() => _TypeScreenState();
}

class _TypeScreenState extends State<TypeScreen> {
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  bool _isLoading = true;
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _fetchQuizData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');
    final String? uri = dotenv.env['PORT'];

    if (uri == null || userId == null) {
      throw Exception('API URI or User ID not found in environment variables.');
    }

    final response = await http.post(
      Uri.parse('$uri/test/start-quiz-test'),
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

  Future<void> _checkAnswer(String answer) async {
    final prefs = await SharedPreferences.getInstance();
    final String? uri = dotenv.env['PORT'];
    final userId = prefs.getString('id');
    final question = _questions[_currentQuestionIndex];

    if (uri == null || userId == null) {
      throw Exception('API URI or User ID not found in environment variables.');
    }

    final response = await http.post(
      Uri.parse('$uri/question/check-quiz-result'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'testId': question['testId'],
        'questionId': question['id'],
        'answer': answer,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result) {
        _correctAnswers++;
      }
    } else {
      throw Exception('Failed to check quiz result');
    }
  }

  void _nextQuestion() async {
    await _checkAnswer(_answerController.text);
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answerController.clear();
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() async {
    _timer?.cancel();
    await _checkAnswer(_answerController.text);
    await _completeQuizTest();
    _showResultDialog();
  }

  Future<void> _completeQuizTest() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uri = dotenv.env['PORT'];
    final testId = _questions.first['testId'];

    if (uri == null || testId == null) {
      throw Exception('API URI or Test ID not found in environment variables.');
    }

    final response = await http.post(
      Uri.parse('$uri/test/complete-quiz-test'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'testId': testId,
        'timeTaken': _elapsedTime.inSeconds,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to complete quiz test');
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Completed'),
          content: Text(
            'You answered $_correctAnswers out of ${_questions.length} questions correctly in ${_elapsedTime.inMinutes}:${_elapsedTime.inSeconds % 60} minutes.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Complete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Type'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                hintText: 'Type your answer here',
              ),
              onChanged: (text) {
                setState(() {}); // To update the state of the button
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _answerController.text.isEmpty ? null : _nextQuestion,
              child: Text(_currentQuestionIndex < _questions.length - 1 ? 'Next' : 'Finish'),
            ),
            SizedBox(height: 20),
            Text(
              'Time: ${_elapsedTime.inMinutes}:${_elapsedTime.inSeconds % 60}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
