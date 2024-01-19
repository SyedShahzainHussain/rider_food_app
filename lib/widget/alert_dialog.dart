import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  const ErrorDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: AlertDialog(
        
        key: key,
        content: Text(
          message!,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Center(child: Text("OK")),
          )
        ],
      ),
    );
  }
}
