import 'package:flutter/material.dart';

class FancyTitle extends StatelessWidget {
  const FancyTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Venti UI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: ' - Be in Control',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
