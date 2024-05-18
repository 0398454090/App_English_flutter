import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrainedWordScreen extends StatefulWidget {
  final String userId;

  const TrainedWordScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _TrainedWordScreenState createState() => _TrainedWordScreenState();
}

class _TrainedWordScreenState extends State<TrainedWordScreen> {
  List<dynamic> trainedWords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrainedWords();
  }

  Future<void> fetchTrainedWords() async {
    final String? URI = dotenv.env['PORT'];
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }

    final url = '$URI/user/get-all-trained-words/${widget.userId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        trainedWords = json.decode(response.body)['trainedWords'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch trained words');
    }
  }

  String getMastery(int count) {
    return count == 1 ? 'Learned' : 'Memorized';
  }

  Color getMasteryColor(int count) {
    return count == 1 ? Colors.green : Colors.blue; // Adjust colors as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trained Words'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : trainedWords.isEmpty
          ? Center(child: Text('No trained words available'))
          : ListView.builder(
        itemCount: trainedWords.length,
        itemBuilder: (context, index) {
          final word = trainedWords[index];
          return ListTile(
            title: Text(word['word']),
            subtitle: Text(word['meaning']),
            trailing: Text(
              getMastery(word['count']),
              style: TextStyle(
                color: getMasteryColor(word['count']),
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
