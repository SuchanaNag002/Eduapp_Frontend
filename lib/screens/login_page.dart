import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container to provide background color and border
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.yellow[100], // Light purple background color
                shape: BoxShape.circle,
                border:
                    Border.all(width: 2, color: Colors.black), // Black border
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular image
                  ClipOval(
                    child: Image.asset(
                      'assets/images/pic.jpg',
                      width: 200, // Adjust width as needed
                      height: 200, // Adjust height as needed
                      fit: BoxFit.cover, // Cover the circular container
                    ),
                  ),
                  // Purple highlight gradient
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.transparent,
                          const Color.fromARGB(255, 165, 151, 21)
                              .withOpacity(0.5),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Spacer
            // Text "GPTuition"
            const Text(
              'GPTuition',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), // Spacer
            // Sign In With Google button
            GestureDetector(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .signInWithGoogle();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/glogo.svg', // Path to your Google logo SVG asset
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Sign In With Google",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
