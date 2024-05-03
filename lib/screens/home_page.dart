import 'package:eduapp/screens/notefromvdo_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/sidebar.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import './quiz_page.dart';
import './askpdf_page.dart';
import '../components/custom_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    AppUser? user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            setState(() {
              _isDrawerOpen = !_isDrawerOpen;
            });
          },
        ),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(30.0, 26.0, 30.0, 10.0),
                      child: Text(
                        "Hello ${user?.displayName ?? 'User'}!",
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 2.0,
                      ),
                      child: Text(
                        'What do you want to learn today?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 26.0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(33),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAEDCB),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.3), // Shadow color
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // Changes the shadow direction
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                user?.photoURL.toString() ?? '',
                              ),
                            ),
                            const SizedBox(width: 25),
                            const Expanded(
                              child: Text(
                                'Learning made fun with AI!',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomCard(
                              title: "Quiz",
                              icon: Icons.quiz,
                              color: const Color(0XFFC6DEF1),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const QuizPage(),
                                  ),
                                );
                              },
                            ),
                            CustomCard(
                              title: "Ask PDF",
                              icon: Icons.library_books_outlined,
                              color: const Color(0XFFDBCDF0),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AskPdfPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomCard(
                              title: "YouTube Notes",
                              icon: Icons.play_circle_fill,
                              color: const Color(0XFFF2C6DE),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const YoutubeNotesGenerator(),
                                  ),
                                );
                              },
                            ),
                            CustomCard(
                              title: "Ask PDF",
                              icon: Icons.library_books_outlined,
                              color: const Color(0XFFC9E4DE),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AskPdfPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isDrawerOpen)
            const Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Sidebar(),
            ),
        ],
      ),
    );
  }
}
