import 'package:flutter/material.dart';

class CustomSnackbar {
  successSnackbar(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white54),
            color: const Color.fromARGB(221, 1, 4, 46)),
        child: Row(
          children: [
            const SizedBox(width: 5),
            Image.asset("assets/images/logoBlack.png", height: 20),
            const Spacer(),
            Text(
              message,
            ),
            const Spacer(),
            const Icon(Icons.verified, size: 20, color: Colors.green),
            const SizedBox(width: 5),
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
