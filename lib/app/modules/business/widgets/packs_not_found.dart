import 'package:flutter/material.dart';

class PacksNotFound extends StatelessWidget {
  final double height;
  final Color color;

  const PacksNotFound({super.key, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 80,
            color: color,
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Failed To Load the Photobooks Data',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
