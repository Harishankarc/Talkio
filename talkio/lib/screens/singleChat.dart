import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talkio/components/UserVoiceMessage.dart';
import 'package:talkio/components/myInput.dart';
import 'package:talkio/components/myText.dart';
import 'package:talkio/components/oppositeMessage.dart';
import 'package:talkio/components/oppositePhotoMessage.dart';
import 'package:talkio/components/oppositeVoiceMessage.dart';
import 'package:talkio/components/userMessage.dart';
import 'package:talkio/components/userPhotoMessage.dart';
import 'package:talkio/screens/videoCall.dart';
import 'package:talkio/utils/constant.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:record/record.dart';

class SingleChat extends StatefulWidget {
  final int id;
  final String recipent_name;
  final String recipent_email;

  const SingleChat({
    super.key,
    required this.id,
    required this.recipent_name,
    required this.recipent_email,
  });

  @override
  State<SingleChat> createState() => _SingleChatState();
}

class _SingleChatState extends State<SingleChat> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<Map<String, dynamic>> messages = [];

  WebSocketChannel? channel;
  String? userEmail;
  bool _isWebSocketReady = false;
  final record = AudioRecorder();
  final ImagePicker _picker = ImagePicker();
  bool isRecording = false;
  bool isTyping = false;

  Color? localColor = appbackground;
  Color? localTextColor = apptextcolor;

  Future<void> startRecording() async {
    if (await record.hasPermission()) {
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/flutter_audio_recorder_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await record.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );
      setState(() {
        isRecording = true;
      });
    }
  }

  Future<void> stopRecording() async {
    final path = await record.stop();
    setState(() {
      isRecording = false;
    });
    if (path != null) {
      final audioBytes = await File(path).readAsBytes();
      final base64Audio = base64Encode(audioBytes);
      final time = getCurrentISTTime();
      setState(() {
        messages.add({
          "chat": "You",
          "message": base64Audio,
          "time": time,
          "type": "voice"
        });
      });

      channel?.sink.add(jsonEncode({
        "type": "voice",
        "from": userEmail,
        "to": widget.recipent_email,
        "message": base64Audio,
        "time": time,
        "format": "m4a"
      }));
      _scrollToBottom();
    }
  }

  @override
  void initState() {
    super.initState();
    userEmail = Supabase.instance.client.auth.currentUser?.email;
    if (userEmail != null) {
      _connectWebSocket();
    }
    messageController.addListener(() {
      setState(() {
        isTyping = messageController.text.trim().isNotEmpty;
      });
    });
  }

  void _connectWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://talkio.sattva2025.site/chat'),
    );

    // Send initial identity message
    channel!.sink.add(jsonEncode({
      "type": "init",
      "email": userEmail,
      "recipent": widget.recipent_email
    }));

    channel!.stream.listen((event) {
      final data = jsonDecode(event);
      if (data['type'] == 'history' && data['history'] != null) {
        setState(() {
          messages.clear();
        });
        for (var msg in data['history']) {
          print(msg);
          setState(() {
            messages.add({
              "type": msg['type'],
              "chat": msg['sender_email'] == userEmail ? "You" : "Other",
              "message": msg['message'] ?? "No message",
              "time": msg['time'] ?? "Unknown time",
            });
          });
        }
        _scrollToBottom();
      }
      if (data['type'] == 'ack') {
        setState(() {
          _isWebSocketReady = true;
        });
        return;
      }
      if (data['type'] == "voice") {
        setState(() {
          messages.add({
            "chat": "Other",
            "type": "voice",
            "message": data['message'],
            "time": data['time'],
            "format": data['format'] ?? "m4a"
          });
        });
        _scrollToBottom();
        return;
      }

      if(data['type'] == 'photo'){
        setState(() {
          messages.add({
            "chat": "Other",
            "type": "photo",
            "message": data['message'],
            "time": data['time'],
          });
        });
        _scrollToBottom();
        return;
      }

      if (data['message'] == 'Connection established') return;

      if (data['message'] != null && data['timeString'] != null) {
        setState(() {
          messages.add({
            "type": "message",
            "chat": "Other",
            "message": data['message'],
            "time": data['timeString'],
          });
        });
        _scrollToBottom();
      } else {
        print("Skipped malformed message: $data");
      }
    });
  }

  String getCurrentISTTime() {
    final nowUtc = DateTime.now().toUtc();
    final istTime = nowUtc.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('HH:mm').format(istTime);
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty || !_isWebSocketReady) return;

    setState(() {
      messages
          .add({"chat": "You", "message": text, "time": getCurrentISTTime()});
    });

    channel?.sink.add(jsonEncode({
      "type": "message",
      "from": userEmail,
      "to": widget.recipent_email,
      "message": text,
      "time": getCurrentISTTime(),
    }));

    messageController.clear();
    _scrollToBottom();
  }

  void sendPhotoMessage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      setState(() {
        messages.add({
          "chat": "You",
          "message": base64Image,
          "type": "photo",
          "time": getCurrentISTTime()
        });
      });
      channel?.sink.add(jsonEncode({
        "type": "photo",
        "from": userEmail,
        "to": widget.recipent_email,
        "message": base64Image,
        "time": getCurrentISTTime(),
      }));
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: appbackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(15),
          child: Wrap(
            children: [
              ListTile(
                title: const Text('Chat Theme',
                    style: TextStyle(color: Colors.white)),
                trailing: SizedBox(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _colorOption(Colors.pink),
                      const SizedBox(width: 10),
                      _colorOption(Colors.blue),
                      const SizedBox(width: 10),
                      _colorOption(appbackground),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: const Text('Clear Chat',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => messages.clear());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          localColor = color;
          localTextColor = Colors.black;
        });
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.white, width: 1),
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel?.sink.close();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: localColor ?? appbackground,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RefreshIndicator(
            onRefresh: () async {
              _connectWebSocket();
            },
            backgroundColor: apptextcolor,
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 10),
                const Divider(color: Colors.white, thickness: 0.1),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final messageText = message['message'] ?? "No message";
                      final messageTime = message['time'] ?? "Unknown time";
                      final photoUrl = message['message'] ?? null;
                      return message['chat'] == "You"
                          ? message['type'] == "voice"
                              ? UserVoiceMessage(
                                  message: messageText, time: messageTime)
                              : message['type'] == "photo"
                                  ? UserPhotoMessage(
                                    pathImage: photoUrl,
                                  )
                                  : UserMessage(
                                      message: messageText,
                                      time: messageTime,
                                    )
                          : message['type'] == "voice"
                              ? OppositeVoiceMessage(
                                  message: messageText, time: messageTime)
                              : message['type'] == "photo"
                                  ? OppositePhotoMessage(
                                    pathImage: photoUrl,
                                  )
                                  : OppositeMessage(
                                      message: messageText, time: messageTime);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                _buildInputBar(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      leading: const CircleAvatar(
        radius: 40,
        backgroundImage: AssetImage('assets/image/profile.jpg'),
      ),
      title: MyText(
        text: widget.recipent_name,
        fontSize: 20,
        textColor: localTextColor ?? apptextcolor,
        fontWeight: FontWeight.bold,
      ),
      subtitle: MyText(
        text: "Online",
        fontSize: 15,
        textColor: localTextColor ?? Colors.green,
        fontWeight: FontWeight.bold,
      ),
      trailing: SizedBox(
        width: 90,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.to(
                    VideoCall(
                      name: widget.recipent_name,
                    ),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 500));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: backButton,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(Icons.videocam_sharp,
                    color: backButtonIcon, size: 30),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _showBottomSheet(context),
              child: const Icon(Icons.more_vert, color: apptextcolor, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              //phto access
              sendPhotoMessage();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backButton,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.photo, color: backButtonIcon, size: 30),
            ),
          ),
          const SizedBox(width: 10),
          MyInput(
            width: MediaQuery.of(context).size.width * 0.7 - 20,
            controller: messageController,
            hintText: "Enter message",
            obscureText: false,
            textColor: Colors.white,
          ),
          const SizedBox(width: 10),
          messageController.text.isNotEmpty
              ? GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: backButton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        const Icon(Icons.send, color: backButtonIcon, size: 30),
                  ),
                )
              : GestureDetector(
                  onLongPress: startRecording,
                  onLongPressUp: stopRecording,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isRecording ? erroText : backButton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(isRecording ? Icons.mic_off : Icons.mic,
                        color: backButtonIcon, size: 30),
                  ),
                ),
        ],
      ),
    );
  }
}
