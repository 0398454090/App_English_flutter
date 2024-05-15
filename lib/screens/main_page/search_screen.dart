import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Word {
  final String word;
  final String meaning;

  Word({required this.word, required this.meaning});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      meaning: json['meaning'],
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Word> _searchResults = [];
  final URI = dotenv.env['PORT'];

  Future<void> _searchWords(String query) async {
    final url = '$URI/word/search?q=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _searchResults = jsonData.map((e) => Word.fromJson(e)).toList();
      });
    } else {
      // Handle error
      print('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Search", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(),
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 2, color: Colors.black),
                    ),
                    hintText: "Search for English words... ",
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        size: 20,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _searchResults.clear();
                        });
                        _searchController.clear();
                      },
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                  ),
                  onSubmitted: (value) {
                    _searchWords(value);
                  },
                ),
              ),
              if (_searchResults.isNotEmpty)
                Column(
                  children: _searchResults.map((word) {
                    return ListTile(
                      title: Text(word.word),
                      subtitle: Text(word.meaning),
                    );
                  }).toList(),
                ),
            ],
          )
        ],
      ),
    );
  }
}
