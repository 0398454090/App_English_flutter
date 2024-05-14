import 'package:app_english/screens/main_page/settings/screens/folder/topic/user_topic_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserFolderScreen extends StatefulWidget {
  const UserFolderScreen({Key? key}) : super(key: key);

  @override
  _UserFolderScreenState createState() => _UserFolderScreenState();
}

class _UserFolderScreenState extends State<UserFolderScreen> {
  String? userId;
  List<dynamic> folders = [];
  bool isLoading = true;
  final String? URI = dotenv.env['PORT'];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    if (id != null) {
      setState(() {
        userId = id;
      });
      _fetchFolders();
    }
  }

  Future<void> _fetchFolders() async {
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final url = '$URI/folder/all/$userId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        folders = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load folders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folders'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
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
                      builder: (context) => TopicPage(folderId: folder['id']),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(10.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(6),
                  leading: Icon(
                    Icons.folder,
                    color: Colors.black38,
                    size: 40,
                  ),
                  title: Text(
                    folder['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (choice) =>
                        _onSelectMenu(choice, folder),
                    itemBuilder: (BuildContext context) {
                      return (folder['topicId'] == null || folder['topicId'].isEmpty)
                          ? ['Update', 'Delete'].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList()
                          : ['Update'].map((String choice) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateFolderDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _onSelectMenu(String choice, dynamic folder) {
    switch (choice) {
      case 'Update':
        _showUpdateDialog(folder);
        break;
      case 'Delete':
        _deleteFolder(folder);
        break;
    }
  }

  void _showUpdateDialog(dynamic folder) {
    String newName = folder['name'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Folder Name'),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            decoration: InputDecoration(hintText: 'New folder name'),
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
                _updateFolder(folder['id'], newName);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updateFolder(String folderId, String newName) async {
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final url = '$URI/folder/update/$folderId';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"newFolderName": newName}),
    );

    if (response.statusCode == 200) {
      print('Folder updated successfully');
      _fetchFolders(); // Refresh the folder list after updating
    } else {
      throw Exception('Failed to update folder');
    }
  }

  void _deleteFolder(dynamic folder) async {
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final url = '$URI/folder/delete/${folder['id']}';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Folder deleted successfully');
      _fetchFolders(); // Refresh the folder list after deleting
    } else {
      throw Exception('Failed to delete folder');
    }
  }

  void _showCreateFolderDialog() {
    String newFolderName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Folder'),
          content: TextField(
            onChanged: (value) {
              newFolderName = value;
            },
            decoration: InputDecoration(hintText: 'Enter folder name'),
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
                _createFolder(newFolderName);
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _createFolder(String folderName) async {
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final url = '$URI/folder/create';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "folderName": folderName}),
    );

    if (response.statusCode == 201) {
      print('Folder created successfully');
      _fetchFolders(); // Refresh the folder list after creating
    } else {
      throw Exception('Failed to create folder');
    }
  }
}
