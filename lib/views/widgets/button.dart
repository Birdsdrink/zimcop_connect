import 'package:flutter/material.dart';
import '../../const/style_const.dart';

class Button extends StatelessWidget {
  final String btnText, loadingMessage;
  final bool isLoading;
  const Button(
      {super.key,
      required this.btnText,
      required this.isLoading,
      required this.loadingMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.4),
          borderRadius: BorderRadius.circular(15)),
      child: Center(
          child: isLoading
              ? Center(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.7, // Scale down to 50%
                      child:
                          const CircularProgressIndicator(color: Colors.blue),
                    ),
                    const SizedBox(width: 20),
                    Text(loadingMessage,
                        style: const TextStyle(
                            color: tittleTextColor,
                            fontWeight: FontWeight.bold))
                  ],
                ))
              : Text(btnText,
                  style: const TextStyle(
                      color: tittleTextColor, fontWeight: FontWeight.bold))),
    );
  }
}
