import 'dart:async';

import 'package:flutter/material.dart';

import '../auth/landing_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState
    extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const LandingPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2563EB),
              Color(0xFF3B82F6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: const Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            CircleAvatar(
              radius: 60,
              backgroundColor:
                  Colors.white,
              child: Icon(
                Icons.school,
                size: 70,
                color:
                    Color(0xFF2563EB),
              ),
            ),

            SizedBox(height: 25),

            Text(
              "SQLearning",
              style: TextStyle(
                fontSize: 34,
                fontWeight:
                    FontWeight.bold,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Media Pembelajaran Interaktif",
              style: TextStyle(
                color:
                    Colors.white70,
                fontSize: 16,
              ),
            ),

            SizedBox(height: 40),

            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}