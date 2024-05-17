import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'flashcard_view.dart';

class FlashCardScreen extends StatefulWidget {
  final String? topicId;

  const FlashCardScreen({Key? key, required this.topicId}) : super(key: key);

  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  List<Map<String, dynamic>> _flashcard = [];
  int currentIdx = 0;
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  String? uid; // User ID

  @override
  void initState() {
    super.initState();
    _retrieveUserId();
    _fetchFlashcards();
  }

  Future<void> _retrieveUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString('id');
    });
  }


  Future<void> _fetchFlashcards() async {
    final String? URI = dotenv.env['PORT'];
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final response = await http.get(Uri.parse('$URI/word/search/${widget.topicId}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _flashcard = data.map((item) => {
          'id': item['id'],
          'word': item['word'],
          'vocab': item['vocab'],
          'meaning': item['meaning'],
        }).toList();
      });
    } else {
      throw Exception('Failed to load flashcards');
    }
  }

  Future<void> addToFavorite() async {
    final String? URI = dotenv.env['PORT'];
    if (URI == null) {
      throw Exception('API URI not found in environment variables.');
    }
    final response = await http.post(
      Uri.parse('$URI/user/add-marked-word/$uid'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'markedId': _flashcard[currentIdx]['id']}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to favorites')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 250,
              child: _flashcard.isNotEmpty
                  ? FlipCard(
                key: cardKey,
                front: FlashCardView(
                  text: _flashcard[currentIdx]['word']!,
                ),
                back: FlashCardView(
                  text: _flashcard[currentIdx]['meaning']!,
                ),
              )
                  : CircularProgressIndicator(),
            ),
            SizedBox(height: 20),
            Text(
              '${currentIdx + 1}/${_flashcard.length}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton.icon(
                  onPressed: showPreviousCard,
                  icon: Icon(Icons.chevron_left),
                  label: Text("Previous"),
                ),
                OutlinedButton.icon(
                  onPressed: addToFavorite,
                  icon: Icon(Icons.favorite),
                  label: Text("Add to favorite"),
                ),
                OutlinedButton.icon(
                  onPressed: showNextCard,
                  icon: Icon(Icons.chevron_right),
                  label: Text("Next"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showNextCard() {
    setState(() {
      currentIdx = (currentIdx + 1) % _flashcard.length;
    });
    cardKey.currentState?.controller?.reset();
  }

  void showPreviousCard() {
    setState(() {
      currentIdx = (currentIdx - 1) % _flashcard.length;
      if (currentIdx < 0) currentIdx = _flashcard.length - 1;
    });
    cardKey.currentState?.controller?.reset();
  }
}

