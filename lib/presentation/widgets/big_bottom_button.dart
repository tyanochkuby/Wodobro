import 'package:flutter/material.dart';

class BigBottomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const BigBottomButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      onPressed: () {
        onPressed;
      },
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color.fromRGBO(245, 245, 247, 0.9),
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
