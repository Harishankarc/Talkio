import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyText extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final bool? textAlign;
  final bool? underline;
  const MyText({super.key, required this.text,this.fontSize,this.fontWeight,this.textColor,this.textAlign,this.underline,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: textAlign == true ? TextAlign.center : TextAlign.left,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          letterSpacing: 1.5,
          decoration: underline == true ? TextDecoration.underline : TextDecoration.none,
          decorationColor: Colors.white,
          color: textColor ?? Colors.white,
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.normal
        ),
      ),
    );
  }
}