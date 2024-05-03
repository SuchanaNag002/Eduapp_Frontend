import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Notes Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const YoutubeNotesGenerator(),
    );
  }
}

class YoutubeNotesGenerator extends StatefulWidget {
  const YoutubeNotesGenerator({Key? key}) : super(key: key);

  @override
  _YoutubeNotesGeneratorState createState() => _YoutubeNotesGeneratorState();
}

class _YoutubeNotesGeneratorState extends State<YoutubeNotesGenerator> {
  String? _youtubeLink;
  String? _selectedSubject;
  String? _customSubject;
  bool _thumbnailLoaded = false;

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(initialVideoId: '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    _youtubeLink = value.trim();
                    _controller = YoutubePlayerController(
                      initialVideoId:
                          YoutubePlayer.convertUrlToId(_youtubeLink!) ?? '',
                      flags: const YoutubePlayerFlags(
                        autoPlay: false,
                        mute: true,
                      ),
                    );
                    _thumbnailLoaded =
                        false; // Reset the flag when link changes
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Enter YouTube link here',
                ),
              ),
              SizedBox(
                height: 200,
                child: _youtubeLink != null
                    ? YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.amber,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.amber,
                          handleColor: Colors.amberAccent,
                        ),
                        onReady: () {
                          setState(() {
                            _thumbnailLoaded = true;
                          });
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                    if (value == 'Other') {
                      _customSubject = null;
                    }
                  });
                },
                items: [
                  'Physics',
                  'Chemistry',
                  'Maths',
                  'Other',
                ].map((subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
              ),
              if (_selectedSubject == 'Other')
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _customSubject = value.trim();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter subject',
                  ),
                ),
              ElevatedButton(
                onPressed: _generateNotes,
                child: const Text('Generate Notes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateNotes() {
    if (_youtubeLink == null || _youtubeLink!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a YouTube link')),
      );
      return;
    }
    if (_selectedSubject == null ||
        (_selectedSubject == 'Other' &&
            (_customSubject == null || _customSubject!.isEmpty))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subject')),
      );
      return;
    }
    // Call your backend API with _youtubeLink and _selectedSubject or _customSubject
  }
}
