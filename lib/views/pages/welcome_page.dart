import 'package:flutter/material.dart';
import '../../const/style_const.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: homeBackgroundColor,
      body: SafeArea(
          child: SizedBox(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              "Welcome to",
              style: TextStyle(fontSize: 15, color: tittleTextColor),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              "Z R P  Messenger",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
              textAlign: TextAlign.center,
            ),
            Expanded(child: Container()),
            SizedBox(
                width: screenWidth * 0.7,
                child: Image.asset('assets/images/welcome.png')),
            Expanded(child: Container()),
            const Text(
              "Facilitating Communication Among Zimbabwe Republic Police Law enforcement agents",
              style: TextStyle(fontSize: 15, color: tittleTextColor),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LogInPage())),
              child: Container(
                height: 40,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                    child: Text(
                  "C o n t i n u e",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
            const Spacer(),
          ],
        ),
      )),
    );
  }
}
