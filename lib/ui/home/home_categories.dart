// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:kokylive/network_models/response_main_data.dart';
// import 'package:kokylive/ui/video_view/video_call_view.dart';

// class HomeCategories extends StatelessWidget {
//   final List<Category> categories;

//   HomeCategories({this.categories});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height/1.7,
//       child: GridView.count(
//           shrinkWrap: true,
//           padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//           crossAxisSpacing: 4.0,
//           mainAxisSpacing: 0,
//           childAspectRatio: 0.9,
//           crossAxisCount: 2,
//           primary: false,
//           scrollDirection: Axis.vertical,
//           children: List.generate(
//             categories.length,
//             (index) => SingleCategoryView(
//               categoryData: categories[index],
//             ),
//           )),
//     );
//   }
// }

// class SingleCategoryView extends StatelessWidget {
//   final Category categoryData;

//   SingleCategoryView({this.categoryData});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (context, animation1, animation2) => VideoView(
//               role: ClientRole.Audience,
//               channelId: '${categoryData.id}',
//             ),
//             transitionsBuilder: (context, animation1, animation2, child) =>
//                 FadeTransition(opacity: animation1, child: child),
//             transitionDuration: Duration(milliseconds: 600),
//           ),
//         );
//       },
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
//         child: Stack(
//           children: <Widget>[
//             Positioned(
//               right: 0,
//               bottom: 0,
//               top: 0,
//               left: 0,
//               child: CachedNetworkImage(
//                 imageUrl: categoryData.image != null ? categoryData.image : '',
//                 fit: BoxFit.fill,
//                 placeholder: (ctx, url) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 },
//               ),
//             ),
//             Positioned(
//                 right: 0,
//                 bottom: 0,
//                 top: 0,
//                 left: 0,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.4),
//                     borderRadius: BorderRadius.all(Radius.circular(8))
//                   ),
//                   width: double.infinity,
//                   height: double.infinity,
//                 )),
//             Positioned(
//               right: 0,
//               bottom: 0,
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Text(
//                   categoryData.name,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: categoryData.name.length > 14 ? 11 : 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
