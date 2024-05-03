import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../sub_screens/questionnaire_page.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> generateQuiz(String topic) async {
    const String apiUrl = 'http://192.168.214.37:8000/generate_questionnaire/';
    final requestBody = jsonEncode({'paragraph': topic});

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      final Map<String, dynamic> responseData = {
        'statusCode': response.statusCode,
        'body': response.body,
      };

      if (response.statusCode == 200) {
        final List<dynamic> questions = json.decode(response.body);
        responseData['questions'] = questions;
      } else {
        print('Failed to fetch questions: ${response.statusCode}');
      }

      return responseData;
    } catch (e) {
      print('Error fetching questions: $e');
      return {
        'statusCode': -1,
        'body': 'Error: $e'
      }; // Indicate error with a negative status code
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController topicController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
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
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image above the text field
            Image.asset(
              'assets/images/quiz.jpg', // Path to your image asset
              height: 100,
              width: 170,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20), // Spacer
            // Text field for entering a topic
            TextField(
              controller: topicController,
              decoration: InputDecoration(
                labelText: 'Enter Topic',
                labelStyle: const TextStyle(color: Colors.black), // Text color
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Border color when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black
                          .withOpacity(0.2)), // Border color when enabled
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacer
            // Button for generating quiz
            ElevatedButton(
              onPressed: () async {
                String topic = topicController.text;
                Map<String, dynamic> quizData = await generateQuiz(topic);
                print('Generating quiz for topic: $topic');
                // Display questions on screen (replace with your UI logic)
                if (quizData['statusCode'] == 200) {
                  List<dynamic> questions = quizData['questions'];
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(questions: questions),
                    ),
                  );
                } else {
                  print('Failed to fetch questions: ${quizData['statusCode']}');
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black, // Text color
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Button border radius
                ),
              ),
              child: const Text(
                'Generate Quiz',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
