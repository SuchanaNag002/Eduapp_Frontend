import 'package:flutter/material.dart';

class ScoreCardScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ScoreCardScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Score Card',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Center(
        child: Text(
          'Your Score: $score out of $totalQuestions',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
