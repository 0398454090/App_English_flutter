import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MarkedWordScreen extends StatefulWidget {
  final String userId;

  const MarkedWordScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MarkedWordScreenState createState() => _MarkedWordScreenState();
}

class _MarkedWordScreenState extends State<MarkedWordScreen> {
  List<dynamic> markedWords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMarkedWords();
  }

  Future<void> _fetchMarkedWords() async {
    final String? URI = dotenv.env['PORT'];
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }

    final url = '$URI/user/get-all-marked-words/${widget.userId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        markedWords = json.decode(response.body)['markedWords'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch marked words');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marked Words'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : markedWords.isEmpty
          ? Center(
        child: Text('No marked words available'),
      )
          : ListView.builder(
        itemCount: markedWords.length,
        itemBuilder: (context, index) {
          final word = markedWords[index];
          return ListTile(
            title: Text(word['word']),
            subtitle: Text(word['meaning']),
          );
        },
      ),
    );
  }
}
