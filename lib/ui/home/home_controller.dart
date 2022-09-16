import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/database/cart_database_crud.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/ui/account/account_controller.dart';
import 'package:kokylive/ui/favorite/favorite_controller.dart';
import 'package:kokylive/ui/search/search_text_controller.dart';
import 'package:kokylive/ui/video_live/video_live_controller.dart';

import 'home_bottom_bar.dart';
import 'home_drawer.dart';

class HomeController extends StatefulWidget {
  static const String id = '/home';

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  PageController _controller = PageController(
    initialPage: 0,
    keepPage: false,
  );

  @override
  void initState() {
    super.initState();
    initCartProvider();
  }

  initCartProvider() async {
    await Firebase.initializeApp();
    CartDatabaseCRUD cartDatabaseCRUD = new CartDatabaseCRUD();
    cartDatabaseCRUD.updateCartProviderList(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: homeAppBar(),
        drawer: HomeDrawer(),
        floatingActionButton: floatingWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: HomeBottomAppBar(
          currentIndex: currentIndex,
          updateCurrentIndex: (value) {
            setState(() {
              currentIndex = value;
              _controller.jumpToPage(value);
            });
          },
        ),
        key: _scaffoldKey,
        body: callPage(currentIndex),
      ),
    );
  }

  Widget floatingWidget() {
    return FloatingActionButton(
      onPressed: ()  {
       setState(() {
         currentIndex = 2;
         _controller.jumpToPage(2);
       });
      },
      backgroundColor: AppColors().primaryColor(),
      child: Icon(Icons.videocam),
    );
  }

  /// Set a type current number a layout class
  Widget callPage(int current) {
    return PageView(
      controller: _controller,
      onPageChanged: (page) {
        setState(() {
          currentIndex = page;
        });
      },
//      pageSnapping: false,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
       // HomeView(),
        SearchTextController(),
        VideoLiveController(),
        FavoriteController(),
        AccountController(),
      ],
    );
  }

  PreferredSizeWidget homeAppBar() {
    return AppBar(
      backgroundColor: AppColors().primaryColor(),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      title: Text(
        YemString().appName,
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        //for drawer icon to be appear
//        Expanded(
//          flex: 1,
//          child: Container(),
//        ),

//        Expanded(
//          flex: 6,
//          child: GestureDetector(
//            onTap: () {
//              Navigator.of(context).pushNamed(SearchTextController.id);
//            },
//            child: Container(
//              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//              decoration: BoxDecoration(
//                color: Colors.white,
//                borderRadius: BorderRadius.all(Radius.circular(4)),
//              ),
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Row(
//                  children: <Widget>[
//                    Icon(
//                      Icons.search,
//                      color: AppColors().primaryColor(),
//                    ),
//                    SizedBox(width: 4),
//                    Text(YemString().searchFor)
//                  ],
//                ),
//              ),
//            ),
//          ),
//        ),
      ],
    );
  }
}
