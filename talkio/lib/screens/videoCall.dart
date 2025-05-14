import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talkio/components/myText.dart';
import 'package:talkio/utils/constant.dart';
import 'dart:math' as math;

class VideoCall extends StatefulWidget {
  final String name;
  const VideoCall({super.key, required this.name});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  List<CameraDescription> cameras = [];
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRecording = false;
  bool _isEnded = false;
  Future<String> getVideoPath() async {
    final dir = await getTemporaryDirectory();
    return join(dir.path, '${DateTime.now()}.mp4');
  }
  void startRecording() async {
    final path = await getVideoPath();
    await _controller.startVideoRecording();
    setState(() {
      _isRecording = true;
    });
  }
  void stopRecording() async {
    // await _controller.stopVideoRecording();
    setState(() {
      _isRecording = false;
      _isEnded = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    initalConfig();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initializeControllerFuture = initalConfig();
  }

  Future<void> initalConfig() async {
    try {
      cameras = await availableCameras();

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _controller.initialize();
      setState(() {});
    } catch (e) {
      print("Camera initialization error: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appbackground,
        body: Stack(
          children: [
            FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi), // import 'dart:math' as math;
                            child: CameraPreview(_controller),
                          );
                }else{
                  return const CircularProgressIndicator(color: apptextcolor,);
                }
              }
            ),
            if (_isEnded)
              const Align(
                alignment: Alignment.center,
                child: MyText(
                  text: "Video Call Ended",
                  fontSize: 20,
                  textColor: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 8.0, right: 8.0, bottom: 8.0),
                child: Column(

                  children: [
                    MyText(text: widget.name, fontSize: 20, textColor: Colors.white, fontWeight: FontWeight.bold,),
                    const MyText(text: "Calling....", fontSize:15, textColor: Colors.white, fontWeight: FontWeight.bold,),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 0, 0),
                        Color.fromARGB(190, 18, 18, 18),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding:const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.more_horiz,
                              color: appbackground,
                              size: 30,
                            )),
                        const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.mic_none_sharp,
                              color: appbackground,
                              size: 30,
                            )),
                        GestureDetector(
                          onTap: (){
                            stopRecording();
                          },
                          child: const CircleAvatar(
                              radius: 30,
                              backgroundColor: erroText,
                              child: Icon(
                                Icons.phone_disabled,
                                color: Colors.white,
                                size: 30,
                              )),
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}