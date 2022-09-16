import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/models/route_argument.dart';
import 'package:kokylive/network_models/response_user_profile.dart';
import 'package:kokylive/repository/update_image_request.dart';
import 'package:kokylive/repository/user_profile_request.dart';
import 'package:permission_handler/permission_handler.dart';

class UserProfileController extends StatefulWidget {
  static const id = "/user_profile";
  final RouteArgument args;

  UserProfileController({this.args});

  @override
  _UserProfileControllerState createState() => _UserProfileControllerState();
}

class _UserProfileControllerState extends State<UserProfileController> {
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
              widget.args.param,
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              FutureBuilder<ResponseUserProfile>(
                future: networkShowUserProfile(widget.args.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...snapshot.data.stickers.map((single) {
                                  return Container(
                                    margin: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        border: Border.all(color: Colors.orangeAccent, width: 1),
                                        boxShadow: [BoxShadow(color: Colors.yellow, spreadRadius: 4, blurRadius: 4)]),
                                    child: CachedNetworkImage(
                                      imageUrl: single.image == null ? '' : single.image,
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
                                }),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            child: Container(
                                color: Colors.grey[200],
                                width: 120,
                                height: 120,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data.data.image == null ? '' : snapshot.data.data.image,
                                    width: 120,
                                    height: 120,
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
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${snapshot.data.data.userId}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${snapshot.data.data.name}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${snapshot.data.data.level}'),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Profile not available'),
                    );
                  } else {
                    return Container();
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
                        decoration:
                            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
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
                        decoration:
                            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.photo_library, size: 50, color: AppColors().primaryColor()),
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
      final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 25);
      String imagePath = File(pickedFile.path).path;
      await networkUpdateImage(imagePath, context);
      setState(() {});
    } else {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 25);
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
      final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 25);
      String imagePath = File(pickedFile.path).path;
      await networkUpdateImage(imagePath, context);
      setState(() {});
    } else {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 25);
        String imagePath = File(pickedFile.path).path;
        await networkUpdateImage(imagePath, context);
        setState(() {});
      }
    }
  }
}
