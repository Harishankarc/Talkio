import 'package:flutter/material.dart';
import 'package:talkio/components/myText.dart';
import 'package:talkio/utils/constant.dart';

class Mybutton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final double? width;
  final double? height;
  final double? border;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? backgroundColor;
  final bool? textAlign;
  const Mybutton({
    super.key,
    required this.text,
    required this.onTap,
    required this.width,
    required this.height,
    this.fontSize,
    this.border,
    this.fontWeight,
    this.backgroundColor,
    this.textColor,
    this.textAlign
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? normalButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(border ?? 5),
          ),
        ),
        onPressed: onTap ,
        child: MyText(text: text,fontSize: fontSize ?? 20,textColor: textColor ?? Colors.white,textAlign: textAlign ?? false ,fontWeight: fontWeight ?? FontWeight.bold,),
      ),
    );
  }
}