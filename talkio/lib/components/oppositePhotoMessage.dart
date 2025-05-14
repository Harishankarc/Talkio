import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class OppositePhotoMessage extends StatelessWidget {
  final String pathImage;
  const OppositePhotoMessage({super.key,required this.pathImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Image.memory(
        base64Decode(pathImage),
        fit: BoxFit.cover,
      ),
    );
  }
}