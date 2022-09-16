import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kokylive/elements/CircularLoadingWidget.dart';
import 'package:kokylive/elements/edit_text.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/shared_pref.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/network_models/response_my_stickers.dart';
import 'package:kokylive/network_models/response_profile.dart';
import 'package:kokylive/repository/my_stickers_request.dart';
import 'package:kokylive/repository/profile_request.dart';
import 'package:kokylive/repository/update_image_request.dart';
import 'package:kokylive/ui/login/login_page.dart';
import 'package:kokylive/ui/splash/splash_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  static const id = "profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: AppColors().primaryColor(),
            centerTitle: true,
            title: Text(
              YemString().myAccount,
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              FutureBuilder<List<Sticker>>(
                future: networkMySticker(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...snapshot.data.map((single) {
                            return Container(
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  border: Border.all(
                                      color: Colors.orangeAccent, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.yellow,
                                        spreadRadius: 4,
                                        blurRadius: 4)
                                  ]),
                              child: CachedNetworkImage(
                                imageUrl:
                                    single.image == null ? '' : single.image,
                                width: 70,
                                height: 70,
                                fit: BoxFit.fill,
                                placeholder: (context, url) {
                                  return Icon(
                                    Icons.perm_identity,
                                    size: 90,
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return Icon(
                                    Icons.perm_identity,
                                    size: 90,
                                  );
                                },
                              ),
                            );
                          })
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder<ProfileData>(
                future: networkGetProfile(context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            color: AppColors().primaryColor(),
                            // ignore: deprecated_member_use
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(LoginController.id);
                              },
                              child: Text(
                                YemString().requireLoginMessage,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return Form(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            GestureDetector(
                                onTap: () {
                                  dialogChooser(context);
                                },
                                child: Text('kgnkbn')
                                // Stack(
                                //   children: [
                                //     ClipRRect(
                                //       borderRadius: BorderRadius.all(Radius.circular(100)),
                                //       child: Container(
                                //           color: Colors.grey[200],
                                //           width: 120,
                                //           height: 120,
                                //           child: Padding(
                                //             padding: const EdgeInsets.all(8.0),
                                //             child: CachedNetworkImage(
                                //               imageUrl: snapshot.data.image == null ? '' : snapshot.data.image,
                                //               width: 120,
                                //               height: 120,
                                //               fit: BoxFit.fill,
                                //               placeholder: (context, url) {
                                //                 return Icon(
                                //                   Icons.perm_identity,
                                //                   size: 90,
                                //                 );
                                //               },
                                //               errorWidget: (context, url, error) {
                                //                 return Icon(
                                //                   Icons.perm_identity,
                                //                   size: 90,
                                //                 );
                                //               },
                                //             ),
                                //           )),
                                //     ),
                                //     Positioned(
                                //       top: 0,
                                //       right: 0,
                                //       child: ClipRRect(
                                //         borderRadius: BorderRadius.all(Radius.circular(100)),
                                //         child: Container(
                                //             color: Colors.black,
                                //             width: 35,
                                //             height: 35,
                                //             child: Padding(
                                //               padding: const EdgeInsets.all(4.0),
                                //               child: Icon(
                                //                 Icons.edit,
                                //                 color: Colors.white,
                                //               ),
                                //             )),
                                //       ),
                                //     )
                                //   ],
                                // ),
                                ),
                            SizedBox(height: 10),
                            EditText(
                              value: snapshot.data.name,
                              iconData: Icons.person,
                              hint: YemString().firstName,
                              enable: false,
                            ),
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                            EditText(
                              value: snapshot.data.email,
                              iconData: Icons.email,
                              enable: false,
                              hint: YemString().email,
                            ),
                            SizedBox(height: 10),
                            EditText(
                              value: snapshot.data.phone,
                              iconData: Icons.phone,
                              enable: false,
                              hint: YemString().phoneHint,
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () async {
                                YemenyPrefs pref = YemenyPrefs();
                                pref.logout(context);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    SplashController.id, (route) => false);
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.power_settings_new,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  YemString().logout,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularLoadingWidget());
                  }
                },
              ),
            ],
          )),
    );
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
