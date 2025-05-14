import 'package:flutter/material.dart';
import 'package:talkio/components/myText.dart';
import 'package:talkio/utils/constant.dart';

class OppositeMessage extends StatelessWidget {
  final String message;
  final String? time;
  const OppositeMessage({super.key, required this.message, this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backButtonIcon,
                borderRadius: BorderRadius.circular(10),
              ),
              child: MyText(
                text: message,
                fontSize: 20,
                textColor: backButton,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: MyText(
                text: time ?? "10:00",
                fontSize: 10,
                textColor: apptextcolor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
