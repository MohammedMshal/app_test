// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:kokylive/helper/app_config.dart';
// import 'package:kokylive/helper/echo.dart';
// import 'package:kokylive/helper/shared_pref.dart';
// import 'package:kokylive/helper/strings.dart';
// import 'package:kokylive/models/main_provider_model.dart';
// import 'package:kokylive/network_models/response_stickers.dart';
// import 'package:kokylive/repository/close_room_request.dart';
// import 'package:kokylive/repository/send_sticker_request.dart';
// import 'package:kokylive/ui/login/login_page.dart';
// import 'package:provider/provider.dart';

// class VideoView extends StatefulWidget {
//   static const id = 'videLive';
//   final String channelId;
//   final ClientRole role;

//   VideoView({this.channelId, this.role});

//   @override
//   _VideoViewState createState() => _VideoViewState();
// }

// class _VideoViewState extends State<VideoView> {
//   static final _users = <int>[];
//   final _infoStrings = <String>[];

//   bool muted = false;
//   ScrollController controller = ScrollController();
//   final TextEditingController textEditingController = TextEditingController();
//   String theUserId = '';
//   String theUserName = '';
//   bool showChat = true, showGifts = false, isFavorite = false;
//   List<Sticker> gifts = new List();
//   String selectedImage = '';
//   double width;
//   double height;

//   @override
//   void dispose() {
//     Echo("tedispose dispose dispose");
//     // clear users
//     _users.clear();
//     // destroy sdk
//     AgoraRtcEngine.leaveChannel();
//     AgoraRtcEngine.destroy();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // initialize agora sdk
//     initialize();
//   }

//   Future<void> initialize() async {
//     await Firebase.initializeApp();
//     if (AppStrings.AGORA_ID.isEmpty) {
//       setState(() {
//         _infoStrings.add(
//           'APP_ID missing, please provide your APP_ID in settings.dart',
//         );
//         _infoStrings.add('Agora Engine is not starting');
//       });
//       return;
//     }

//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     await AgoraRtcEngine.enableWebSdkInteroperability(true);
//     VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
//     configuration.dimensions = Size(480, 264);
//     await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
//     await AgoraRtcEngine.joinChannel(null, widget.channelId, null, 0);
//   }

//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     await AgoraRtcEngine.create(AppStrings.AGORA_ID);
//     await AgoraRtcEngine.enableVideo();
//     await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await AgoraRtcEngine.setClientRole(widget.role);
//   }

//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     AgoraRtcEngine.onError = (dynamic code) {
//       setState(() {
//         final info = 'onError: $code';
//         _infoStrings.add(info);
//       });
//       Echo('_infoStrings5 = ${_infoStrings.length}');
//     };

//     AgoraRtcEngine.onJoinChannelSuccess = (
//       String channel,
//       int uid,
//       int elapsed,
//     ) {
//       setState(() {
//         final info = 'onJoinChannel: $channel, uid: $uid';
//         _infoStrings.add(info);
//       });
//     };

//     AgoraRtcEngine.onLeaveChannel = () {
//       setState(() {
//         _infoStrings.add('onLeaveChannel');
//         _users.clear();
//       });
//       Echo('_infoStrings4 = ${_infoStrings.length}');
//     };

//     AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
//       setState(() {
//         final info = 'userJoined: $uid';
//         _infoStrings.add(info);
//         _users.add(uid);
//       });
//       Echo('users2 = ${_users.length}');
//       Echo('_infoStrings3 = ${_infoStrings.length}');
//     };

//     AgoraRtcEngine.onUserOffline = (int uid, int reason) {
//       setState(() {
//         final info = 'userOffline: $uid';
//         _infoStrings.add(info);
//         _users.remove(uid);
//       });
//       Echo('_infoStrings2 = ${_infoStrings.length}');
//     };

//     AgoraRtcEngine.onFirstRemoteVideoFrame = (
//       int uid,
//       int width,
//       int height,
//       int elapsed,
//     ) {
//       setState(() {
//         final info = 'firstRemoteVideo: $uid ${width}x $height';
//         _infoStrings.add(info);
//       });

//       Echo('_infoStrings = ${_infoStrings.length}');
//     };
//   }

//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     final List<AgoraRenderWidget> list = [];
//     if (widget.role == ClientRole.Broadcaster) {
//       list.add(AgoraRenderWidget(0, local: true, preview: true));
//     }
//     _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
//     Echo('users3 = ${_users.length}');
// //    networkCloseRoom(widget.channelId, context);
//     return list;
//   }

//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }

//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }

//   /// Video layout wrapper
//   Widget _viewRows() {
//     final views = _getRenderViews();
//     if (views.isNotEmpty)
//       return Container(
//         child: Stack(
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 _videoView(views[0]),
//               ],
//             ),
//             Positioned(
//               top: 0,
//               left: 0,
//               child: Container(
//                 margin: EdgeInsets.all(12),
//                 padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.5),
//                     borderRadius: BorderRadius.all(Radius.circular(8))),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.remove_red_eye,
//                       color: Colors.black,
//                     ),
//                     SizedBox(
//                       width: 4,
//                     ),
//                     Text('${_users.length}')
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 0,
//               right: 10,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Container(
//                   margin: EdgeInsets.all(12),
//                   padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                   decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.5),
//                       borderRadius: BorderRadius.all(Radius.circular(8))),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.close,
//                         color: Colors.black,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     else {
//       return Container(
// //        color: Colors.red,
//         child: Center(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Image.asset(
//               'assets/img/ic_no_video.png',
//               width: 90,
//               height: 90,
//             ),
//             SizedBox(
//               height: 4,
//             ),
//             Text('غير متاح!')
//           ],
//         )),
//       );
//     }

//     return Container();
//   }

//   /// Toolbar layout
//   Widget _toolbar() {
//     if (widget.role == ClientRole.Audience) return Container();
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           RawMaterialButton(
//             onPressed: _onToggleMute,
//             child: Icon(
//               muted ? Icons.mic_off : Icons.mic,
//               color: muted ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: muted ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           ),
//           RawMaterialButton(
//             onPressed: () => _onCallEnd(context),
//             child: Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15.0),
//           ),
//           RawMaterialButton(
//             onPressed: _onSwitchCamera,
//             child: Icon(
//               Icons.switch_camera,
//               color: Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           )
//         ],
//       ),
//     );
//   }

//   /// Info panel to show logs
//   Widget _panel() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       alignment: Alignment.bottomCenter,
//       child: FractionallySizedBox(
//         heightFactor: 0.5,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           child: ListView.builder(
//             reverse: true,
//             itemCount: _infoStrings.length,
//             itemBuilder: (BuildContext context, int index) {
//               if (_infoStrings.isEmpty) {
//                 return null;
//               }
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 3,
//                   horizontal: 10,
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 2,
//                           horizontal: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.yellowAccent,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Text(
//                           _infoStrings[index],
//                           style: TextStyle(color: Colors.blueGrey),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   void _onCallEnd(BuildContext context) {
//     Navigator.pop(context);
//   }

//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     AgoraRtcEngine.muteLocalAudioStream(muted);
//   }

//   void _onSwitchCamera() {
//     AgoraRtcEngine.switchCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     MainProviderModel mainProviderModel =
//         Provider.of<MainProviderModel>(context, listen: false);
//     gifts = mainProviderModel.stickers;
//     width = MediaQuery.of(context).size.width;
//     height = MediaQuery.of(context).size.height;
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           height: height,
//           width: width,
//           child: Stack(
//             children: <Widget>[
//               _viewRows(),
//               if (showChat)
//                 Positioned(
//                   bottom: 75,
//                   left: 0,
//                   right: 0,
//                   top: 0,
//                   child: Column(
//                     children: [
//                       Expanded(
//                         flex: 3,
//                         child: StreamBuilder(
//                           stream: FirebaseFirestore.instance
//                               .collection('koky')
//                               .doc(widget.channelId)
//                               .collection('messages')
//                               .orderBy('time', descending: true)
//                               .limit(40)
//                               .snapshots(),
//                           builder: (context, snapshot) {
//                             if (!snapshot.hasData) {
//                               return Container();
//                             } else if (snapshot.data.documents.length < 1) {
//                               return Container();
//                             } else {
//                               return ListView.builder(
// //           controller: controller
//                                 padding: EdgeInsets.all(10.0),
//                                 itemBuilder: (context, index) => buildItem(
//                                     index: index,
//                                     document: snapshot.data.documents[index],
//                                     context: context,
//                                     width: MediaQuery.of(context).size.width),
//                                 itemCount: snapshot.data.documents.length,
//                                 reverse: true,
// //              controller: listScrollController,
//                               );
//                             }
//                           },
//                         ),
//                       ),
//                       buildInput(),
//                     ],
//                   ),
//                 ),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 top: 0,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
// //        Icon(
// //          Icons.favorite_border,
// //          size: 90,
// //          color: AppColors().primaryColor(),
// //        ),
// //        Text(
// //          YemString().empty,
// //          style: TextStyle(fontSize: 22),
// //        ),

//                     if (showGifts)
//                       Container(
//                         margin: EdgeInsets.all(8),
//                         padding: EdgeInsets.all(8),
//                         width: double.infinity,
//                         height: 200,
//                         decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.4),
//                             borderRadius: BorderRadius.circular(8.0)),
//                         child: gifts == null
//                             ? Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     YemString().mustLoginToViewAndSendStickers,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             : gifts.length < 1
//                                 ? Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child:
//                                           Text(YemString().requireLoginMessage),
//                                     ),
//                                   )
//                                 : GridView.count(
//                                     shrinkWrap: true,
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 8.0, vertical: 8.0),
//                                     crossAxisSpacing: 4.0,
//                                     mainAxisSpacing: 16.0,
//                                     childAspectRatio: 1.2,
//                                     crossAxisCount: 4,
//                                     primary: false,
//                                     children:
//                                         List.generate(gifts.length, (index) {
//                                       return Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Flexible(
//                                             flex: 2,
//                                             child: GestureDetector(
//                                               onTap: () {
//                                                 if (mainProviderModel
//                                                             .profileData !=
//                                                         null &&
//                                                     mainProviderModel
//                                                             .profileData
//                                                             .coins !=
//                                                         null) {
//                                                   if (mainProviderModel
//                                                           .profileData.coins >
//                                                       gifts[index].coins) {
//                                                     mainProviderModel
//                                                             .profileData.coins =
//                                                         mainProviderModel
//                                                                 .profileData
//                                                                 .coins -
//                                                             gifts[index].coins;
//                                                     showGiftAnimation(
//                                                         gifts[index].image,
//                                                         '${gifts[index].id}');
//                                                   }
//                                                 }
//                                               },
//                                               child: Container(
//                                                 width: 50,
//                                                 child: ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             500.0),
//                                                     child: CachedNetworkImage(
//                                                       imageUrl:
//                                                           gifts[index].image,
//                                                       errorWidget: (context,
//                                                           url, error) {
//                                                         return CircularProgressIndicator();
//                                                       },
//                                                       placeholder:
//                                                           (context, url) {
//                                                         return CircularProgressIndicator();
//                                                       },
//                                                     )),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           500.0),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color:
//                                                           generateRandomColor(),
//                                                       blurRadius: 4,
//                                                       spreadRadius: 4,
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Flexible(
//                                               flex: 1,
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 children: [
//                                                   Image.asset(
//                                                     'assets/img/ic_coin.png',
//                                                     width: 12,
//                                                   ),
//                                                   SizedBox(width: 4),
//                                                   Text(
//                                                     '${gifts[index].coins}',
//                                                     style: TextStyle(
//                                                         color: Colors.white),
//                                                   ),
//                                                 ],
//                                               )),
//                                         ],
//                                       );
//                                     })),
//                       ),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               if (isFavorite) {
//                                 isFavorite = false;
//                               } else {
//                                 isFavorite = true;
//                               }
//                             });
//                           },
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Icon(
//                                 Icons.favorite_border,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             decoration: BoxDecoration(
//                               color: isFavorite ? Colors.red : Colors.grey,
//                               borderRadius: BorderRadius.circular(100.0),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: isFavorite ? Colors.red : Colors.grey,
//                                   blurRadius: isFavorite ? 2 : 0,
//                                   spreadRadius: isFavorite ? 2 : 0,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               if (showGifts) {
//                                 showGifts = false;
//                               } else {
//                                 showGifts = true;
//                               }
//                             });
//                           },
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Icon(
//                                 Icons.card_giftcard,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             decoration: BoxDecoration(
//                               color: showGifts
//                                   ? Colors.yellow.shade700
//                                   : Colors.grey,
//                               borderRadius: BorderRadius.circular(100.0),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: showGifts
//                                       ? Colors.yellow.shade700
//                                       : Colors.grey,
//                                   blurRadius: showGifts ? 2 : 0,
//                                   spreadRadius: showGifts ? 2 : 0,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               if (showChat) {
//                                 showChat = false;
//                               } else {
//                                 showChat = true;
//                               }
//                             });
//                           },
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Icon(
//                                 Icons.chat,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             decoration: BoxDecoration(
//                               color: showChat ? Colors.blue : Colors.grey,
//                               borderRadius: BorderRadius.circular(100.0),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: showChat ? Colors.blue : Colors.grey,
//                                   blurRadius: showChat ? 2 : 0,
//                                   spreadRadius: showChat ? 2 : 0,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(
//                       height: 20,
//                     )
//                   ],
//                 ),
//               ),

//               if (selectedImage.isNotEmpty)
//                 Positioned(
//                     left: 0,
//                     right: 0,
//                     top: 0,
//                     bottom: 0,
//                     child: TweenAnimationBuilder(
//                       key: Key(selectedImage),
//                       duration: Duration(milliseconds: 2000),
//                       tween: Tween<double>(begin: 0, end: 2),
//                       builder: (context, value, child) {
//                         Echo('$value');
//                         if (value == 2) {
//                           selectedImage = '';
//                           return Container();
//                         }
//                         return Transform.scale(
//                           scale: value > 1 ? 2 - value : value,
//                           child: CachedNetworkImage(
//                             imageUrl: selectedImage,
//                             errorWidget: (context, url, error) {
//                               return CircularProgressIndicator();
//                             },
//                             placeholder: (context, url) {
//                               return CircularProgressIndicator();
//                             },
//                           ),
//                         );
//                       },
//                     )),

//               if (mainProviderModel.profileData != null &&
//                   mainProviderModel.profileData.coins != null)
//                 Positioned(
//                   right: 0,
//                   top: 35,
//                   child: Container(
//                     margin: EdgeInsets.all(12),
//                     padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                     decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.5),
//                         borderRadius: BorderRadius.all(Radius.circular(8))),
//                     child: Center(
//                         child: Text(
//                             '${mainProviderModel.profileData.coins} ${YemString().coin}')),
//                   ),
//                 ),

// //            _panel(),
// //              Positioned(
// //                  top: 0,
// //                  left: 0,
// //                  right: 0,
// //                  child: _toolbar()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildItem(
//       {BuildContext context,
//       int index,
//       DocumentSnapshot document,
//       double width}) {
//     //download

//     // Right (my message)
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: <Widget>[
//         Opacity(
//           opacity: 1 - (0.1 * index),
//           child: Container(
//             child: ChatMessageText(
//               document: document,
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget buildInput() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16),
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: <Widget>[
//           // Edit text
//           Flexible(
//             child: Container(
//               child: TextField(
//                 style: TextStyle(color: Colors.black, fontSize: 12.0),
//                 controller: textEditingController,
//                 decoration: InputDecoration.collapsed(
//                   hintText: 'اكتب رسالتك ...',
//                   hintStyle: TextStyle(color: Colors.grey),
//                 ),
//               ),
//             ),
//           ),

//           // Button send message
//           Material(
//             child: new Container(
//               margin: new EdgeInsets.symmetric(horizontal: 8.0),
//               child: new IconButton(
//                 icon: new Icon(Icons.send),
//                 onPressed: () {
//                   if (textEditingController.text != null &&
//                       textEditingController.text.length > 0) {
//                     sendNewChatMessage(textEditingController.text);
//                     textEditingController.clear();
//                   }
//                 },
//                 color: Colors.blue,
//               ),
//             ),
//             color: Colors.white,
//           ),
//         ],
//       ),
//       width: double.infinity,
//       height: 51.0,
//       decoration: new BoxDecoration(
//           border:
//               new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
//           color: Colors.white),
//     );
//   }

//   void sendNewChatMessage(String message) async {
//     if (theUserId == null ||
//         theUserName == null ||
//         theUserId.isEmpty ||
//         theUserName.isEmpty) {
//       YemenyPrefs prefs = YemenyPrefs();
//       int userId = await prefs.getUserId();
//       String name = await prefs.getFirstName();
//       if (userId != null && name != null) {
//         theUserId = '$userId';
//         theUserName = '$name';

//         FirebaseFirestore.instance
//             .collection('koky')
//             .doc(widget.channelId)
//             .collection('messages')
//             .doc(DateTime.now().millisecondsSinceEpoch.toString())
//             .set(
//           {
//             'id': '$theUserId',
//             'name': theUserName,
//             'message': message,
//             'time': '${DateTime.now().millisecondsSinceEpoch}',
//           },
//         );
//       } else {
//         AwesomeDialog(
//           context: context,
//           animType: AnimType.TOPSLIDE,
//           dialogType: DialogType.INFO,
//           title: YemString().notification,
//           desc: YemString().requireLoginMessage,
//           btnOkText: YemString().login,
//           btnOkColor: Colors.green,
//           btnOkOnPress: () {
//             Navigator.of(context).pop();
//             Navigator.of(context).pushNamed(LoginController.id);
//           },
//         ).show();
//       }
//     } else {
//       FirebaseFirestore.instance
//           .collection('koky')
//           .doc(widget.channelId)
//           .collection('messages')
//           .doc(DateTime.now().millisecondsSinceEpoch.toString())
//           .set(
//         {
//           'id': '$theUserId',
//           'name': theUserName,
//           'message': message,
//           'time': '${DateTime.now().millisecondsSinceEpoch}',
//         },
//       );
//     }
//   }

//   void showGiftAnimation(String image, String stickerId) {
//     FirebaseFirestore.instance
//         .collection('koky')
//         .doc(widget.channelId)
//         .collection('gifts')
//         .doc(DateTime.now().millisecondsSinceEpoch.toString())
//         .set(
//       {
//         'coin': 200,
//         'image': image,
//       },
//     );
//     setState(() {
//       selectedImage = image;
//     });

//     networkSendSticker(widget.channelId, stickerId);
//   }
// }

// MaterialColor generateRandomColor() {
//   return Colors.deepPurple;
// }

// class ChatMessageText extends StatefulWidget {
//   final DocumentSnapshot document;

//   const ChatMessageText({this.document});

//   @override
//   _ChatMessageTextState createState() => _ChatMessageTextState();
// }

// class _ChatMessageTextState extends State<ChatMessageText> {
//   @override
//   Widget build(BuildContext context) {
//     double width = (MediaQuery.of(context).size.width / 1.3);
//     return Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           Container(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               child: Text(
//                 widget.document.get('message'),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 13,
//                 ),
//                 textAlign: TextAlign.right,
//               ),
//             ),
//             decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.4),
//                 borderRadius: BorderRadius.circular(20.0)),
//           ),
//           SizedBox(width: 4),
//           Container(
//             width: 34,
//             height: 34,
//             child: Center(
//               child: Text(
//                 '${widget.document.get('name').toString().characters.first.toUpperCase()}${widget.document.get('name').toString().substring(1).characters.first.toUpperCase()}',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 13,
//                 ),
//                 textAlign: TextAlign.right,
//               ),
//             ),
//             decoration: BoxDecoration(
//               color: userFirstLetterColor(widget.document.get('name')),
//               borderRadius: BorderRadius.circular(100.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: userFirstLetterColor(widget.document.get('name')),
//                   blurRadius: 2,
//                   spreadRadius: 2,
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   MaterialColor userFirstLetterColor(String name) {
//     String firstCharacter = name.characters.first;

//     if (firstCharacter.contains('a')) {
//       return Colors.red;
//     }
//     if (firstCharacter.contains('b')) {
//       return Colors.red;
//     }
//     if (firstCharacter.contains('c')) {
//       return Colors.green;
//     }
//     if (firstCharacter.contains('d')) {
//       return Colors.green;
//     }
//     if (firstCharacter.contains('e')) {
//       return Colors.yellow;
//     }
//     if (firstCharacter.contains('f')) {
//       return Colors.yellow;
//     }
//     if (firstCharacter.contains('g')) {
//       return Colors.teal;
//     }
//     if (firstCharacter.contains('h')) {
//       return Colors.teal;
//     }
//     if (firstCharacter.contains('i')) {
//       return Colors.deepPurple;
//     }
//     if (firstCharacter.contains('j')) {
//       return Colors.deepPurple;
//     }
//     if (firstCharacter.contains('k')) {
//       return Colors.orange;
//     }
//     if (firstCharacter.contains('l')) {
//       return Colors.orange;
//     }
//     if (firstCharacter.contains('m')) {
//       return Colors.blue;
//     }
//     if (firstCharacter.contains('n')) {
//       return Colors.blue;
//     }
//     if (firstCharacter.contains('o')) {
//       return Colors.lightBlue;
//     }
//     if (firstCharacter.contains('p')) {
//       return Colors.lightBlue;
//     }
//     if (firstCharacter.contains('q')) {
//       return Colors.indigo;
//     }
//     if (firstCharacter.contains('r')) {
//       return Colors.indigo;
//     }
//     if (firstCharacter.contains('s')) {
//       return Colors.cyan;
//     }
//     if (firstCharacter.contains('t')) {
//       return Colors.cyan;
//     }

//     if (firstCharacter.contains('u')) {
//       return Colors.purple;
//     }

//     if (firstCharacter.contains('v')) {
//       return Colors.purple;
//     }
//     if (firstCharacter.contains('w')) {
//       return Colors.pink;
//     }
//     if (firstCharacter.contains('x')) {
//       return Colors.pink;
//     }
//     if (firstCharacter.contains('y')) {
//       return Colors.lime;
//     }
//     if (firstCharacter.contains('z')) {
//       return Colors.black;
//     }
//     return Colors.deepOrange;
//   }
// }

// class GiftClass {
//   String imageUrl;
//   int id;
//   int points;
//   MaterialColor color;

//   GiftClass({this.imageUrl, this.id, this.points, this.color});
// }
