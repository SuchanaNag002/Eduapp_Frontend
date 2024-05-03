import 'package:flutter/material.dart';
import 'scorecard_page.dart';

class QuizScreen extends StatefulWidget {
  final List<dynamic> questions;

  const QuizScreen({Key? key, required this.questions}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  String? _selectedAnswer; // Track the selected answer
  int _score = 0; // Track the user's score

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0), // Added padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the quiz question
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question['Question'],
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Display answer options
            Column(
              children: List.generate(
                4,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAnswer = String.fromCharCode(65 + index);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedAnswer == String.fromCharCode(65 + index)
                          ? Colors.grey[500]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: String.fromCharCode(65 + index),
                          groupValue: _selectedAnswer,
                          onChanged: (_) {
                            setState(() {
                              _selectedAnswer = String.fromCharCode(65 + index);
                            });
                          },
                          // Set radio button color
                          activeColor: Colors.black,
                        ),
                        Flexible(
                          // Wrap the Text with Flexible
                          child: Text(
                            question[String.fromCharCode(65 + index)],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Previous and Next buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentQuestionIndex == 0
                      ? null
                      : () {
                          setState(() {
                            _currentQuestionIndex--;
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black, // Text color
                  ),
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Calculate the score for the current question
                    updateScore(question);

                    if (_currentQuestionIndex < widget.questions.length - 1) {
                      setState(() {
                        _currentQuestionIndex++;
                        _selectedAnswer = null; // Reset the selected answer
                      });
                    } else {
                      // Navigate to the score card
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScoreCardScreen(
                            score: _score,
                            totalQuestions: widget.questions.length,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black, // Text color
                  ),
                  child: _currentQuestionIndex < widget.questions.length - 1
                      ? const Text('Next')
                      : const Text('Finish'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateScore(Map<String, dynamic> question) {
    String correctAnswer = question['CorrectAnswer'];
    print("Correct answer|selected answer : $correctAnswer $_selectedAnswer");

    if (_selectedAnswer == correctAnswer) {
      setState(() {
        _score++;
      });
    }
  }
}
