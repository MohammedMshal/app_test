// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:kokylive/helper/app_config.dart';
// import 'package:kokylive/helper/echo.dart';
// import 'package:kokylive/helper/shared_pref.dart';
// import 'package:kokylive/repository/close_room_request.dart';

// class VideoLive extends StatefulWidget {
//   static const id = 'videLive';
//   final String channelId;
//   final ClientRole role;
//   bool cameraOn;

//   VideoLive({this.channelId, this.role, this.cameraOn = true});

//   @override
//   _VideoLiveState createState() => _VideoLiveState();
// }

// class _VideoLiveState extends State<VideoLive> {
//   static final _users = <int>[];
//   final _infoStrings = <String>[];

//   bool muted = false;
//   ScrollController controller = ScrollController();
//   final TextEditingController textEditingController = TextEditingController();
//   String theUserId = '';
//   String theUserName = '';
//   bool showChat = true;
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
//     networkCloseRoom(widget.channelId, null);
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // initialize agora sdk
//     initialize();
//     getGiftsStream();
//   }

//   Future<void> initialize() async {
//     Firebase.initializeApp();
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
//     configuration.dimensions = Size(1920, 1080);
//     await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
//     await AgoraRtcEngine.joinChannel(null, widget.channelId, null, 0);
//   }

//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     await AgoraRtcEngine.create(AppStrings.AGORA_ID);
//     if (widget.cameraOn == true)
//       await AgoraRtcEngine.enableVideo();
//     else
//       AgoraRtcEngine.disableVideo();
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
//     };

//     AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
//       setState(() {
//         final info = 'userJoined: $uid';
//         _infoStrings.add(info);
//         _users.add(uid);
//       });
//     };

//     AgoraRtcEngine.onUserOffline = (int uid, int reason) {
//       setState(() {
//         final info = 'userOffline: $uid';
//         _infoStrings.add(info);
//         _users.remove(uid);
//       });
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
//     };
//   }

//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     Echo('_getRenderViews');
//     final List<AgoraRenderWidget> list = [];
//     if (widget.role == ClientRole.Broadcaster) {
//       Echo('widget.role ${widget.role}');
//       list.add(AgoraRenderWidget(0, local: true, preview: true));
//       Echo('list add ${list.length}');
//     }
//     Echo('_users.forEach');
//     _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
//     Echo('_users ${_users.length}');
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
//     if (views.isNotEmpty) {
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
//                     color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.all(Radius.circular(8))),
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
// //            Positioned(
// //              top: 0,
// //              right: 10,
// //              child: GestureDetector(
// //                onTap: () {
// //                  Navigator.of(context).pop();
// //                },
// //                child: Container(
// //                  margin: EdgeInsets.all(12),
// //                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// //                  decoration: BoxDecoration(
// //                      color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.all(Radius.circular(8))),
// //                  child: Row(
// //                    children: [
// //                      Icon(
// //                        Icons.close,
// //                        color: Colors.black,
// //                      ),
// //                    ],
// //                  ),
// //                ),
// //              ),
// //            ),
//           ],
//         ),
//       );
//     }

//     return Container();
//   }

//   /// Toolbar layout
//   Widget _toolbar() {
//     if (widget.role == ClientRole.Audience) return Container();
//     return Container(
//       alignment: Alignment.bottomCenter,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           RawMaterialButton(
//             onPressed: () => _onCallEnd(context),
//             child: Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15.0),
//           ),

//           SizedBox(height: 12),
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
//           SizedBox(height: 12),

// //          RawMaterialButton(
// //            onPressed: _onSwitchCamera,
// //            child: Icon(
// //              Icons.perm_camera_mic,
// //              color: Colors.blueAccent,
// //              size: 20.0,
// //            ),
// //            shape: CircleBorder(),
// //            elevation: 2.0,
// //            fillColor: Colors.white,
// //            padding: const EdgeInsets.all(12.0),
// //          )
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
//               if (selectedImage.isNotEmpty)
//                 Positioned(
//                     left: 0,
//                     top: 0,
//                     right: 0,
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
//                           child: Padding(
//                             padding: const EdgeInsets.all(25.0),
//                             child: CachedNetworkImage(
//                               width: 100,
//                               height: 100,
//                               imageUrl: selectedImage,
//                               errorWidget: (context, url, error) {
//                                 return CircularProgressIndicator();
//                               },
//                               placeholder: (context, url) {
//                                 return CircularProgressIndicator();
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                     )),
//               Positioned(top: 10, right: 0, child: _toolbar()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   getGiftsStream() {
//     FirebaseFirestore.instance
//         .collection('koky')
//         .doc(widget.channelId)
//         .collection('gifts')
//         .limit(1)
//         .snapshots()
//         .listen((snapShot) {
//       if (snapShot.docs.length > 0)
//         setState(() {
//           selectedImage = snapShot.docs[0].get('image');
//         });
//       if (snapShot.docs.length > 0)
//         FirebaseFirestore.instance
//             .collection('koky')
//             .doc(widget.channelId)
//             .collection('gifts')
//             .doc(snapShot.docs[0].id)
//             .delete();
//     });
//   }

//   Widget buildItem({BuildContext context, int index, DocumentSnapshot document, double width}) {
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
//                   if (textEditingController.text != null && textEditingController.text.length > 0) {
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
//           border: new Border(top: new BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
//     );
//   }

//   void sendNewChatMessage(String message) async {
//     if (theUserId.isEmpty || theUserName.isEmpty) {
//       YemenyPrefs prefs = YemenyPrefs();
//       int userId = await prefs.getUserId();
//       String name = await prefs.getFirstName();
//       theUserId = '$userId';
//       theUserName = '$name';
//     }
//     FirebaseFirestore.instance
//         .collection('koky')
//         .doc(widget.channelId)
//         .collection('messages')
//         .doc(DateTime.now().millisecondsSinceEpoch.toString())
//         .set(
//       {
//         'id': '$theUserId',
//         'name': theUserName,
//         'message': message,
//         'time': '${DateTime.now().millisecondsSinceEpoch}',
//       },
//     );
//   }
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
//     if (widget.document.get('message') == null || widget.document.get('name') == null) return Container();
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
//             decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(20.0)),
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
//       return Colors.red.shade900;
//     }
//     if (firstCharacter.contains('c')) {
//       return Colors.green;
//     }
//     if (firstCharacter.contains('d')) {
//       return Colors.green.shade900;
//     }
//     if (firstCharacter.contains('e')) {
//       return Colors.yellow;
//     }
//     if (firstCharacter.contains('f')) {
//       return Colors.yellow.shade900;
//     }
//     if (firstCharacter.contains('g')) {
//       return Colors.teal;
//     }
//     if (firstCharacter.contains('h')) {
//       return Colors.teal.shade900;
//     }
//     if (firstCharacter.contains('i')) {
//       return Colors.deepPurple;
//     }
//     if (firstCharacter.contains('j')) {
//       return Colors.deepPurple.shade900;
//     }
//     if (firstCharacter.contains('k')) {
//       return Colors.orange;
//     }
//     if (firstCharacter.contains('l')) {
//       return Colors.orange.shade900;
//     }
//     if (firstCharacter.contains('m')) {
//       return Colors.blue;
//     }
//     if (firstCharacter.contains('n')) {
//       return Colors.blue.shade900;
//     }
//     if (firstCharacter.contains('o')) {
//       return Colors.lightBlue;
//     }
//     if (firstCharacter.contains('p')) {
//       return Colors.lightBlue.shade900;
//     }
//     if (firstCharacter.contains('q')) {
//       return Colors.indigo;
//     }
//     if (firstCharacter.contains('r')) {
//       return Colors.indigo.shade900;
//     }
//     if (firstCharacter.contains('s')) {
//       return Colors.cyan;
//     }
//     if (firstCharacter.contains('t')) {
//       return Colors.cyan.shade900;
//     }
//     if (firstCharacter.contains('u')) {
//       return Colors.purple;
//     }
//     if (firstCharacter.contains('v')) {
//       return Colors.purple.shade900;
//     }
//     if (firstCharacter.contains('w')) {
//       return Colors.pink;
//     }
//     if (firstCharacter.contains('x')) {
//       return Colors.pink.shade900;
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
