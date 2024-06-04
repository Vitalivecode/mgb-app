import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mygallerybook/core/app_colors.dart';

class MyTextFormField extends StatelessWidget {
  final String? hintText;
  final String? lable;
  final  validator;
  final  onSaved;
  final bool? isNumber;
  final bool? isenable;
  final bool? isobscure;
  final Widget? icon;
  final int? number;
  final int? maxlines;
  final  TextEditingController? controller;
  const MyTextFormField({super.key,
    this.hintText,
    this.lable,
    this.validator,
    this.onSaved,
    this.number,
    this.icon,
    this.controller,
    this.maxlines,
    this.isNumber = false,
    this.isenable = true,
    this.isobscure = false,
  });
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding:
      EdgeInsets.symmetric(vertical: width * .02, horizontal: width * .04),
      child: TextFormField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: width * .04, inherit: true, color: Colors.black),
        decoration: InputDecoration(
            errorStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: width * .03, fontWeight: FontWeight.w900, color: AppColors.red),
            prefixIcon: icon,
            isDense: true,
            labelText: lable,
            labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: width * .04,
                inherit: true,
                color: Colors.black.withOpacity(.8)),
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: width * .04,
                inherit: true,
                color: Colors.black.withOpacity(.4)),
            contentPadding: EdgeInsets.symmetric(vertical: width * .04),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(width * .04),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: AppColors.blue.withOpacity(.15)),
        enabled: isenable,
        validator: validator,
        onSaved: onSaved,
        keyboardType: isNumber! ? TextInputType.number : TextInputType.text,
        obscureText: isobscure!,
        maxLines: maxlines ?? 1,
        inputFormatters: isNumber!
            ? <TextInputFormatter>[
          LengthLimitingTextInputFormatter(number),
          // ignore: deprecated_member_use
          FilteringTextInputFormatter.digitsOnly,
          // FilteringTextInputFormatter.singleLineFormatter
        ]
            : null,
      ),
    );
  }
}