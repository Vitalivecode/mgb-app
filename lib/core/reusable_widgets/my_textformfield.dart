import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mygallerybook/core/app_colors.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    this.icon,
    this.label,
    this.number,
    this.onSaved,
    this.maxLines,
    this.hintText,
    this.validator,
    this.controller,
    this.enabled = true,
    this.isNumber = false,
    this.obscureText = false,
  });

  final int? number;
  final Widget? icon;
  final String? label;
  final bool? enabled;
  final int? maxLines;
  final bool? isNumber;
  final String? hintText;
  final bool? obscureText;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: width * .02,
        horizontal: width * .04,
      ),
      child: TextFormField(
        onSaved: onSaved,
        enabled: enabled,
        validator: validator,
        controller: controller,
        maxLines: maxLines ?? 1,
        obscureText: obscureText!,
        keyboardType: isNumber! ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber!
            ? <TextInputFormatter>[
                LengthLimitingTextInputFormatter(number),
                // ignore: deprecated_member_use
                FilteringTextInputFormatter.digitsOnly,
                // FilteringTextInputFormatter.singleLineFormatter
              ]
            : null,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: width * .04,
              inherit: true,
              color: Colors.black,
            ),
        decoration: InputDecoration(
          filled: true,
          isDense: true,
          labelText: label,
          prefixIcon: icon,
          hintText: hintText,
          fillColor: AppColors.blue.withOpacity(.15),
          contentPadding: EdgeInsets.symmetric(vertical: width * .04),
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(width * .04),
          ),
          errorStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.red,
                fontSize: width * .03,
                fontWeight: FontWeight.w900,
              ),
          labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                inherit: true,
                fontSize: width * .04,
                color: Colors.black.withOpacity(.8),
              ),
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                inherit: true,
                fontSize: width * .04,
                color: Colors.black.withOpacity(.4),
              ),
        ),
      ),
    );
  }
}
