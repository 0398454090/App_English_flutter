import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WordPage extends StatefulWidget {
  final String topicId;

  WordPage({required this.topicId});

  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  List<dynamic> words = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  Future<void> _fetchWords() async {
    final String? URI = dotenv.env['PORT'];
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }

    final url = '$URI/word/search/${widget.topicId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        words = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch words');
    }
  }

  void _showAddWordDialog() {
    String newWord = '';
    String newMeaning = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Word'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newWord = value;
                },
                decoration: InputDecoration(labelText: 'Word'),
              ),
              TextField(
                onChanged: (value) {
                  newMeaning = value;
                },
                decoration: InputDecoration(labelText: 'Meaning'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add word logic
                _addWord(newWord, newMeaning);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addWord(String word, String meaning) {
    // Implement logic to add word
  }
  void _importWordsFromCSV(String topicId) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Words'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : words.isEmpty
          ? Center(
        child: Text('No words available'),
      )
          : ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return ListTile(
            title: Text(word['word']),
            subtitle: Text(word['meaning']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show options for adding a word
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add Word'),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddWordDialog();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.file_upload),
                    title: Text('Import from CSV'),
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
