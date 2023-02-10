// @dart=2.9
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../main.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key key}) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> with AutomaticKeepAliveClientMixin {
  CameraController _controller;
  List<CameraDescription> _cameras = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  bool isCaptured = false;
  String imgPath = '';
  XFile imageCap;

  bool isPhotoCaptred = false;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      _controller = CameraController(_cameras[0], ResolutionPreset.medium);
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } catch (_) {
      logger.i("Exemption: $_");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_controller != null) {
      if (!_controller.value.isInitialized) {
        return Container();
      }
    } else {
      return const Center(
        child: SizedBox(),
      );
    }

    if (!_controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          isPhotoCaptred == false ? _buildCameraPreview() : _showCapturedImage(),
          Positioned(top: 24.0, left: 10.0, right: 10.0, child: _appbarOnCameraView()),
          // Positioned(
          //   top: 24.0,
          //   left: 12.0,
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.switch_camera,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       _onCameraSwitch();
          //     },
          //   ),
          // ),
          // if (_isRecordingMode)
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   top: 32.0,
          //   child: VideoTimer(
          //     key: _timerKey,
          //   ),
          // )
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _appbarOnCameraView() {
    return isPhotoCaptred == false
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    )),
                Spacer(),
                SizedBox(width: 20.0),
                InkWell(
                    onTap: () {
                      _onCameraSwitch();
                    },
                    child: Icon(
                      Icons.flip_camera_ios_outlined,
                      color: Colors.white,
                    )),
              ],
            ),
          )
        : SizedBox();
  }

  Widget _buildBottomNavigationBar() {
    return Container(
        color: Colors.transparent, //Theme.of(context).bottomAppBarColor,
        height: 100.0,
        width: double.infinity,
        child: Center(
          child: Column(
            children: [
              if (!isPhotoCaptred)
                Text(
                  'Tap to click the photo',
                  style: TextStyle(fontSize: 12.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              SizedBox(
                height: 10.0,
              ),
              if (!isPhotoCaptred)
                InkWell(
                    onTap: () {
                      _captureImage();
                      isPhotoCaptred = true;
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 70,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        ),
                        Positioned(
                          right: 0.0,
                          top: 0.0,
                          bottom: 0.0,
                          left: 0.0,
                          child: Center(
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    )),
              if (isPhotoCaptred)
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                isPhotoCaptred = false;
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 30.0,
                              )),
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.white, size: 30.0),
                            onPressed: () {
                              Navigator.pop(context, imgPath);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }

  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    return ClipRect(
      child: Container(
        height: size.height,
        //width: size.width,
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: CameraPreview(_controller),
        ),
      ),
    );
  }

  Future<void> _onCameraSwitch() async {
    final CameraDescription cameraDescription = (_controller.description == _cameras[0]) ? _cameras[1] : _cameras[0];
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        showInSnackBar('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _captureImage() async {
    if (_controller.value.isInitialized) {
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/media';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${_timestamp()}.jpeg';
      print('path: ${filePath}');

      var xFile = await _controller.takePicture();
      print('path1: ${xFile.path}');

      imageCap = xFile;
      //  showCapturedImage(xFile?.path);
      // _controller!.value.isPreviewPaused;
      isCaptured = true;
      imgPath = '${xFile.path}';
      setState(() {});
    }
  }

  Widget _showCapturedImage() {
    return InkWell(
      onTap: () {},
      child: Center(
        child: Image.file(
          File(imgPath),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void _showCameraException(CameraException e) {
    logError(e.code, '${e.description}');
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void logError(String code, String message) => print('Error: $code\nError Message: $message');

  @override
  bool get wantKeepAlive => true;
}
