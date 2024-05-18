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
          // Adding a gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFCFDF6), Color(0xFFD7E1EC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white70.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Color(0xFF020E22)),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Search for English words... ",
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.5)),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 30,
                        color: Color(0xFF020E22),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 20,
                          color: Color(0xFF020E22),
                        ),
                        onPressed: () {
                          setState(() {
                            _searchResults.clear();
                          });
                          _searchController.clear();
                        },
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    onSubmitted: (value) {
                      _searchWords(value);
                    },
                  ),
                ),
              ),
              if (_searchResults.isNotEmpty)
                Column(
                  children: _searchResults.map((word) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: ListTile(
                        title: Text(word.word,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(word.meaning),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
