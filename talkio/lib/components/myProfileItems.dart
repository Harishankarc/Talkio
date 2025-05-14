import 'package:flutter/material.dart';
import 'package:talkio/components/myText.dart';
import 'package:talkio/utils/constant.dart';

class MyProfileItems extends StatelessWidget {
  final String text;
  final IconData iconData;
  final VoidCallback onPressed;
  const MyProfileItems({super.key,required this.iconData, required this.text,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Icon(
                iconData,
                size: 25,
                color: apptextcolor,
              ),
              const SizedBox(
                width: 30,
              ),
              MyText(
                text: text,
                fontSize: 25,
                textColor: apptextcolor,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: apptextcolor,
          )
        ]),
      ),
    );
  }
}