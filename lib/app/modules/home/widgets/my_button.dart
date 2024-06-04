import 'package:flutter/material.dart';
import 'package:mygallerybook/core/app_colors.dart';

class MyButton extends StatelessWidget {
  final Function onPress;
  final String btntext;
  final Color color;
  final Color textcolor;
  final bool border;

  const MyButton(
      {super.key, required this.onPress,
        required this.btntext,
        required this.color,
        required this.textcolor,
        this.border = true});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return MaterialButton(
      onPressed:()=> onPress(),
      padding: EdgeInsets.symmetric(vertical: width * .04),
      minWidth: width * .8,
      elevation: 0,
      color: border ? color : Colors.transparent,
      splashColor: AppColors.darkBlue,
      shape: border
          ? RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * .03))
          : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * .03),
          side: BorderSide(color: color, width: 3)),
      child: Text(btntext,
          style: TextStyle(
              color: textcolor,
              letterSpacing: .6,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              fontSize: width * .05)),
    );
  }
}
