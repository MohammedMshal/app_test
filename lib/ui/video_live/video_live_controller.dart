// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kokylive/elements/CircularLoadingWidget.dart';
import 'package:kokylive/elements/no_internet_conn.dart';
import 'package:kokylive/elements/server_error.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/network_models/response_profile.dart';
import 'package:kokylive/repository/create_room_request.dart';
import 'package:kokylive/repository/profile_request.dart';
import 'package:kokylive/repository/update_image_request.dart';
import 'package:kokylive/ui/login/login_page.dart';
import 'package:permission_handler/permission_handler.dart';


class VideoLiveController extends StatefulWidget {
  @override
  _VideoLiveControllerState createState() => _VideoLiveControllerState();
}

class _VideoLiveControllerState extends State<VideoLiveController> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileData>(
        future: networkGetProfile(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      YemString().startLiveVideo,
                      style: TextStyle(
                          fontSize: 16, color: AppColors().primaryColor()),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        dialogChooser(context);
//
//                Navigator.of(context).pop();
//                Navigator.of(context).pushNamed(ProfileScreen.id);
                      },
                      child: Text('''kdfnknb''')
                      // Stack(
                      //   children: [
                      //     ClipRRect(
                      //       borderRadius: BorderRadius.all(Radius.circular(1000)),
                      //       child: Container(
                      //           color: Colors.grey[200],
                      //           width: MediaQuery.of(context).size.width / 2,
                      //           height: MediaQuery.of(context).size.width / 2,
                      //           child: CachedNetworkImage(
                      //             imageUrl: snapshot.data.image == null ? '' : snapshot.data.image,
                      //             width: MediaQuery.of(context).size.width / 2,
                      //             height: MediaQuery.of(context).size.width / 2,
                      //             fit: BoxFit.fill,
                      //             placeholder: (context, url) {
                      //               return Icon(
                      //                 Icons.perm_identity,
                      //                 size: 70,
                      //                 color: Colors.grey[700],
                      //               );
                      //             },
                      //             errorWidget: (context, url, error) {
                      //               return Icon(
                      //                 Icons.perm_identity,
                      //                 size: 70,
                      //                 color: Colors.grey[700],
                      //               );
                      //             },
                      //           )),
                      //     ),
                      //     Positioned(
                      //       top: 0,
                      //       right: 0,
                      //       child: ClipRRect(
                      //         borderRadius: BorderRadius.all(Radius.circular(100)),
                      //         child: Container(
                      //             color: Colors.black.withOpacity(0.6),
                      //             width: 40,
                      //             height: 40,
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Icon(
                      //                 Icons.edit,
                      //                 color: Colors.white,
                      //               ),
                      //             )),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      ),
                  VideoLiveView(snapshot.data.image),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            if (snapshot.error == null) {
              return ServerErrorWidget(refresh: () {
                setState(() {});
              });
            }
            if (snapshot.error == 'network') {
              return NoInternetConnection(refresh: () {
                setState(() {});
              });
            }
            if (snapshot.error == 'auth') {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.orangeAccent,
                    size: MediaQuery.of(context).size.width / 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(LoginController.id);
                      },
                      child: Text(YemString().requireLoginMessage,
                          style: TextStyle(fontSize: 14, color: Colors.white)))
                ],
              );
            }
            if (snapshot.error == 'json') {
              return ServerErrorWidget(refresh: () {
                setState(() {});
              });
            }
            return Text(' ${snapshot.error.toString()}');
          } else
            return Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: CircularLoadingWidget(),
            ));
        });
  }

  void dialogChooser(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      openCamera();
                      Navigator.pop(context);
                    },
                    child: Card(
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: AppColors().primaryColor(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      openGallery();
                      Navigator.pop(context);
                    },
                    child: Card(
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.photo_library,
                              size: 50, color: AppColors().primaryColor()),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void openCamera() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 25);
      String imagePath = File(pickedFile.path).path;
      await networkUpdateImage(imagePath, context);
      setState(() {});
    } else {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile =
            await picker.getImage(source: ImageSource.camera, imageQuality: 25);
        String imagePath = File(pickedFile.path).path;
        await networkUpdateImage(imagePath, context);
        setState(() {});
      }
    }
  }

  void openGallery() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 25);
      String imagePath = File(pickedFile.path).path;
      await networkUpdateImage(imagePath, context);
      setState(() {});
    } else {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.getImage(
            source: ImageSource.gallery, imageQuality: 25);
        String imagePath = File(pickedFile.path).path;
        await networkUpdateImage(imagePath, context);
        setState(() {});
      }
    }
  }
}

class VideoLiveView extends StatefulWidget {
  final String imageUrl;

  VideoLiveView(this.imageUrl);

  @override
  _VideoLiveViewState createState() => _VideoLiveViewState();
}

class _VideoLiveViewState extends State<VideoLiveView> {
  bool loading = false;
  bool videoAndAudio = true;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: YemString().title,
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        child: Icon(
                          Icons.text_fields,
                          color: AppColors().primaryColor(),
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      videoAndAudio = true;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: videoAndAudio
                            ? AppColors().primaryColor()
                            : Colors.grey[300],
                        boxShadow: [
                          BoxShadow(color: Colors.grey),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 2),
                      child: Text(
                        'Video & Audio',
                        style: TextStyle(
                            color: videoAndAudio ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      videoAndAudio = false;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: !videoAndAudio
                            ? AppColors().primaryColor()
                            : Colors.grey[300],
                        boxShadow: [
                          BoxShadow(color: Colors.grey),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 2),
                      child: Text(
                        'Only Audio',
                        style: TextStyle(
                            color:
                                !videoAndAudio ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 24),
            if (loading)
              CircularProgressIndicator()
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (await Permission.camera.request().isGranted &&
                        await Permission.microphone.request().isGranted) {
                      if (textEditingController.text != null &&
                          textEditingController.text.isNotEmpty) {
                        setState(() {
                          loading = true;
                        });
                        String roomId = await networkCreateRoom(
                            textEditingController.text, context);
                        if (roomId != null) {
                          setState(() {
                            loading = false;
                          });
                          // Navigator.push(
                          //   context,
                          //   PageRouteBuilder(
                          //     pageBuilder: (context, animation1, animation2) => VideoLive(
                          //      // role: ClientRole.Broadcaster,
                          //       channelId: roomId,
                          //       cameraOn: videoAndAudio,
                          //     ),
                          //     transitionsBuilder: (context, animation1, animation2, child) =>
                          //         FadeTransition(opacity: animation1, child: child),
                          //     transitionDuration: Duration(milliseconds: 600),
                          //   ),
                          // );
                        } else {
                          Flushbar(
                            backgroundColor: Colors.red,
                            title: '',
                            message: YemString().serverError,
                            flushbarPosition: FlushbarPosition.TOP,
                            duration: Duration(seconds: 2),
                          )..show(context);
                        }
                      } else {
                        Flushbar(
                          backgroundColor: Colors.red,
                          title: '',
                          message:
                              '${YemString().title} ${YemString().required}',
                          flushbarPosition: FlushbarPosition.TOP,
                          duration: Duration(seconds: 2),
                        )..show(context);
                      }
                    } else {
                      var status = await Permission.camera.request();
                      if (status.isGranted) {
                        var status2 = await Permission.microphone.request();
                        if (status2.isGranted) {}
                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    child: Center(
                      child: Text(
                        YemString().start,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
