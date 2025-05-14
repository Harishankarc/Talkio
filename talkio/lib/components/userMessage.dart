import 'package:flutter/material.dart';
import 'package:talkio/components/myText.dart';
import 'package:talkio/utils/constant.dart';

class UserMessage extends StatelessWidget {
  final String message;
  final String? time;
  const UserMessage({super.key,required this.message, this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backButton,
                borderRadius: BorderRadius.circular(10),
              ),
              child: MyText(
                text:
                    message,
                fontSize: 20,
                textColor: apptextcolor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
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