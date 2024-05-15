import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

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
    String newVocab = ''; // Added vocab field

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
                  newVocab = value;
                },
                decoration: InputDecoration(labelText: 'Vocab'),
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
                _addWord(newWord, newVocab, newMeaning, widget.topicId);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUpdateWordDialog(dynamic word) async {
    String updatedWord = word['word'];
    String updatedVocab = word['vocab'];
    String updatedMeaning = word['meaning'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Word'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  updatedWord = value;
                },
                controller: TextEditingController(text: word['word']),
                decoration: InputDecoration(labelText: 'Word'),
              ),
              TextField(
                onChanged: (value) {
                  updatedVocab = value;
                },
                controller: TextEditingController(text: word['vocab']),
                decoration: InputDecoration(labelText: 'Vocab'),
              ),
              TextField(
                onChanged: (value) {
                  updatedMeaning = value;
                },
                controller: TextEditingController(text: word['meaning']),
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
                _updateWord(word['id'], updatedWord, updatedVocab, updatedMeaning);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addWord(String word, String vocab, String meaning, String topicId) async {
    final String? URI = dotenv.env['PORT'];
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }

    final url = '$URI/word/add';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'word': word,
        'vocab': vocab,
        'meaning': meaning,
        'topicId': topicId,
      }),
    );

    if (response.statusCode == 200) {
      print('Word added successfully');
      _fetchWords(); // Refresh the word list
    } else {
      print('Failed to add word: ${response.reasonPhrase}');
    }
  }

  Future<void> _updateWord(String id, String word, String vocab, String meaning) async {
    final String? URI = dotenv.env['PORT'];
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }

    final url = '$URI/word/edit/$id';
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'word': word,
        'vocab': vocab,
        'meaning': meaning,
      }),
    );

    if (response.statusCode == 200) {
      print('Word updated successfully');
      _fetchWords(); // Refresh the word list
    } else {
      print('Failed to update word: ${response.reasonPhrase}');
    }
  }

  Future<void> _deleteWord(String id) async {
    final String? URI = dotenv.env['PORT'];
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }

    final url = '$URI/word/delete/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Word deleted successfully');
      _fetchWords(); // Refresh the word list
    } else {
      print('Failed to delete word: ${response.reasonPhrase}');
    }
  }

  Future<void> _importWordsFromCSV(String topicId, File file) async {
    final String? URI = dotenv.env['PORT'];
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }

    final url = Uri.parse('$URI/word/add-from-csv');
    final request = http.MultipartRequest('POST', url)
      ..fields['topicId'] = topicId
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Words added successfully from CSV');
      _fetchWords(); // Refresh the word list
    } else {
      print('Failed to add words: ${response.reasonPhrase}');
    }
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
          return Slidable(
            key: ValueKey(word['_id']),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => _showUpdateWordDialog(word),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Update',
                ),
                SlidableAction(
                  onPressed: (context) => _showDeleteConfirmDialog(word['id']),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              title: Text(word['word']),
              subtitle: Text(word['meaning']),
            ),
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
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['csv'],
                      );
                      if (result != null) {
                        final file = File(result.files.single.path!);
                        await _importWordsFromCSV(widget.topicId, file);
                      }
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

  void _showDeleteConfirmDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Word'),
          content: Text('Are you sure you want to delete this word?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteWord(id);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

void main() async {
  await dotenv.load();
  runApp(MaterialApp(
    home: WordPage(topicId: 'your_topic_id'), // Replace with actual topic ID
  ));
}
