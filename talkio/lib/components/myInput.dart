import 'package:flutter/material.dart';
import 'package:talkio/utils/constant.dart';

class MyInput extends StatelessWidget {
  final String? hintText;
  final bool? obscureText;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final bool? textalign;
  final Color? fillColor;
  final Color? borderColor;
  final Color? textColor;

  const MyInput(
      {super.key,
      this.hintText,
      required this.controller,
      this.obscureText,
      this.width,
      this.height,
      this.textalign,
      this.fillColor,
      this.borderColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: TextField(
        controller: controller,
        obscureText: obscureText ?? false,
        textAlign: textalign == null ? TextAlign.left : TextAlign.center,
        style: TextStyle(color: textColor ?? Colors.black,fontSize: 20),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: backButtonIcon, width: 1), // Adjusted width
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: fillColor ?? backButton,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: borderColor ??
                  appbackground, // Default to appBackground if null
              width: 1, // Adjusted width
            ),
          ),
        ),
      ),
    );
  }
}
