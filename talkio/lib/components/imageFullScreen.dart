import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ImageFullScreen extends StatefulWidget {
  final Uint8List pathImage;
  const ImageFullScreen({super.key,required this.pathImage});

  @override
  State<ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.white,size: 30,),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric( horizontal: 10),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                widget.pathImage,
                width: MediaQuery.of(context).size.width,
                // height: 300,
                fit: BoxFit.contain,
              ),
            )
        ),
      ),
    );
  }
}