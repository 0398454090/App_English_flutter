import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flash Cards'),
      ),
      body: Center(
        child: Text(
          'This is the Flash Card Screen',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
