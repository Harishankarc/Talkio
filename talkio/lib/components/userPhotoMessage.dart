import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:talkio/components/imageFullScreen.dart';

class UserPhotoMessage extends StatefulWidget {
  final String pathImage;
  const UserPhotoMessage({super.key, required this.pathImage});

  @override
  State<UserPhotoMessage> createState() => _UserPhotoMessageState();
}

class _UserPhotoMessageState extends State<UserPhotoMessage> {
  late Uint8List imageBytes;
  @override
  void initState() {
    super.initState();
    imageBytes = base64Decode(widget.pathImage);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        alignment: Alignment.centerRight,
        child: GestureDetector(
            onTap: () {
              setState(() {
                Get.to(() => ImageFullScreen(pathImage: imageBytes));
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                imageBytes,
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            )));
  }
}
