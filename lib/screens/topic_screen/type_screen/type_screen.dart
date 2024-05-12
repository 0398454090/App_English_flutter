import 'package:flutter/material.dart';

class TypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Type'),
      ),
      body: Center(
        child: Text(
          'Type',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
