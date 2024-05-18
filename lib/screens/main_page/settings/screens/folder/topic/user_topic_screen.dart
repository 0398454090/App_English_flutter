import 'package:app_english/screens/main_page/settings/screens/folder/topic/word/user_word_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:skeletonizer/skeletonizer.dart';

class TopicPage extends StatefulWidget {
  final String folderId;

  TopicPage({required this.folderId});

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  List<dynamic> topics = [];
  bool isLoading = true;
  final String? URI = dotenv.env['PORT'];

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  Future<void> _fetchTopics() async {
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final url = '$URI/topic/get/${widget.folderId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        topics = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load topics');
    }
  }

  void _onSelectMenu(String choice, dynamic topic) {
    switch (choice) {
      case 'Update':
        _showUpdateDialog(topic);
        break;
      case 'Delete':
        _deleteTopic(topic);
        break;
      case 'Toggle Public':
        _toggleTopicPublic(topic);
        break;
    }
  }

  void _showUpdateDialog(dynamic topic) {
    String newName = topic['name'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Topic Name'),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            decoration: InputDecoration(hintText: 'New topic name'),
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
                _updateTopic(topic['id'], newName);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updateTopic(String topicId, String newName) async {
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final url = '$URI/topic/update/$topicId';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"newName": newName}),
    );

    if (response.statusCode == 200) {
      print('Topic updated successfully');
      _fetchTopics(); // Refresh the topic list after updating
    } else {
      throw Exception('Failed to update topic');
    }
  }

  void _deleteTopic(dynamic topic) async {
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final url = '$URI/topic/delete/${topic['id']}';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Topic deleted successfully');
      _fetchTopics(); // Refresh the topic list after deleting
    } else {
      throw Exception('Failed to delete topic');
    }
  }

  void _toggleTopicPublic(dynamic topic) async {
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final url = '$URI/topic/public/${topic['id']}';
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Topic visibility toggled successfully');
      _fetchTopics(); // Refresh the topic list after toggling visibility
    } else {
      throw Exception('Failed to toggle topic visibility');
    }
  }

  void _showCreateTopicDialog() {
    String newTopicName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Topic'),
          content: TextField(
            onChanged: (value) {
              newTopicName = value;
            },
            decoration: InputDecoration(hintText: 'Enter topic name'),
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
                _createTopic(newTopicName);
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _createTopic(String topicName) async {
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final url = '$URI/topic/create';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"folderId": widget.folderId, "topicName": topicName}),
    );

    if (response.statusCode == 201) {
      print('Topic created successfully');
      _fetchTopics(); // Refresh the topic list after creating
    } else {
      throw Exception('Failed to create topic');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics'),
      ),
      body: Skeletonizer(
        ignoreContainers: true,
        enabled: isLoading,
        child: topics.isEmpty
            ? Center(
          child: Text(
            'No topics available',
            style: TextStyle(fontSize: 18),
          ),
        )
            : ListView.builder(
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
                        builder: (context) => WordPage(topicId: topic['id']),
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
                      topic['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: topic['public']
                        ? Text(
                      'Public',
                      style: TextStyle(color: Colors.green),
                    )
                        : Text(
                      'Private',
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (choice) =>
                          _onSelectMenu(choice, topic),
                      itemBuilder: (BuildContext context) {
                        final List<String> options = ['Update'];
                        if ((topic['wordId'] as List).isEmpty) {
                          options.add('Delete');
                        }
                        options.add('Toggle Public');
                        return options.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                      icon: Icon(Icons.more_vert),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTopicDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
