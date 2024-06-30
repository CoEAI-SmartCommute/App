import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(BuildContext context, String content) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm'),
        // content: const Text(
        //     'Do you want this emergency contact removed ?'),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}
