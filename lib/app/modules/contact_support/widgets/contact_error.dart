import 'package:flutter/material.dart';
import 'package:mygallerybook/core/app_colors.dart';

class ContactError extends StatelessWidget {
  const ContactError({
    required this.height,
    super.key,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height * 0.5,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 80,
            color: AppColors.red,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Failed To Load the Contact Data',
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
