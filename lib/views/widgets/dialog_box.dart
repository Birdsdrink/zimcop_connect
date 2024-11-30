import 'package:flutter/material.dart';

class CustomDialog {
  ////Dialog for confirming logout
  void yesNoConfirmDialog({
    required BuildContext context,
    required String dialogTittle,
    required String dialogText,
    required Function() function,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text(dialogTittle),
              content: Text(dialogText),
              actions: [
                //Cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                //Yes button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    function;
                  },
                  child: const Text("Yes"),
                ),
              ],
            ));
  }
}
