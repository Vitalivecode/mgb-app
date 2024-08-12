import 'package:flutter/material.dart';

class MyGalleryBookBackground extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final String image;
  final Color textColor;

  const MyGalleryBookBackground({
    super.key,
    required this.height,
    required this.width,
    required this.color,
    required this.image,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: height,
      width: width,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 150,
          ),
          const SizedBox(height: 12),
          Text(
            'My Gallery Book',
            style: textTheme.bodyLarge!.copyWith(
                fontSize: 26, color: textColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
