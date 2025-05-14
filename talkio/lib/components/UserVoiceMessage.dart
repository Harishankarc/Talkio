import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talkio/components/myText.dart';
import 'package:talkio/utils/constant.dart';

class UserVoiceMessage extends StatefulWidget {
  final String message;

  final String? time;
  const UserVoiceMessage({super.key,required this.message, this.time});

  @override
  State<UserVoiceMessage> createState() => _UserVoiceMessageState();
}

class _UserVoiceMessageState extends State<UserVoiceMessage> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  Future<void> _playAudio() async {
    try {
      print("Njan evde ende");
      final bytes = base64Decode(widget.message);
      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a');
      await file.writeAsBytes(bytes);

      await _player.setFilePath(file.path);
      _player.play();
      setState(() => isPlaying = true);

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() => isPlaying = false);
        }
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backButton,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Adjust width to content
              children: [
                const SizedBox(width: 5),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: _playAudio,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Icon(
                        isPlaying ? Icons.stop : Icons.play_arrow_rounded,
                        color: backButtonIcon,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const MyText(
                  text: "Voice Message sent",
                  fontSize: 15,
                  textColor: apptextcolor,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: MyText(
              text: widget.time ?? "10:00",
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
    );
  }
}
