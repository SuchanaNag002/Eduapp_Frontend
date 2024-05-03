import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class AskPdfPage extends StatefulWidget {
  const AskPdfPage({Key? key}) : super(key: key);

  @override
  State<AskPdfPage> createState() => _AskPdfPageState();
}

class _AskPdfPageState extends State<AskPdfPage> {
  late TextEditingController _questionController;
  String? _pdfFilePath;
  bool _uploadingPdf = false;
  String _pdfFileName = '';
  String? _answer;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _setPdfFileName(String? filePath) {
    if (filePath != null && filePath.isNotEmpty) {
      _pdfFileName = filePath.split('/').last;
    } else {
      _pdfFileName = 'Unknown PDF';
    }
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      setState(() {
        _pdfFilePath = result.files.single.path;
        _setPdfFileName(_pdfFilePath);
      });
    }
  }

  Future<void> _uploadPdfAndQuestion() async {
    if (_pdfFilePath == null || _pdfFilePath!.isEmpty) {
      // Handle case where no PDF file is selected
      return;
    }

    setState(() {
      _uploadingPdf = true;
    });

    try {
      var uri = Uri.parse('http://192.168.214.37:8000/ask_question/');
      var request = http.MultipartRequest('POST', uri);
      request.fields['question'] = _questionController.text;
      request.files
          .add(await http.MultipartFile.fromPath('pdf_file', _pdfFilePath!));

      var response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = await response.stream.bytesToString();
        var data = jsonDecode(jsonResponse);
        setState(() {
          _answer = data['response'];
        });
      } else {
        print('Error uploading PDF and question: ${response.statusCode}');
        // Handle error
      }
    } catch (e) {
      print('Error uploading PDF and question: $e');
      // Handle error
    } finally {
      setState(() {
        _uploadingPdf = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Ask Pdf',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _uploadingPdf ? null : _pickPdf,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Pick PDF',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Selected PDF: $_pdfFileName',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    hintText: 'Enter your question...',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Make it rounder
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Remove blue border on focus
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                  cursorColor: Colors.black, // Set cursor color to black
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadingPdf || _pdfFilePath == null
                      ? null
                      : _uploadPdfAndQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _uploadingPdf
                      ? const CircularProgressIndicator()
                      : const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Upload PDF and Question',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                if (_answer != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _answer!,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                const SizedBox(height: 50), // Space below content
              ],
            ),
          ),
        ),
      ),
    );
  }
}
