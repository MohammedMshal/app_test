import 'package:flutter/material.dart';
import 'package:kokylive/elements/CircularLoadingWidget.dart';
import 'package:kokylive/elements/no_internet_conn.dart';
import 'package:kokylive/elements/server_error.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/echo.dart';
import 'package:kokylive/models/main_provider_model.dart';
import 'package:kokylive/repository/main_data_request.dart';
import 'package:kokylive/ui/home/home_slider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<SingleFilterModel> filterList = [];
  int selectedFilterModelId = 1;

  @override
  void initState() {
    super.initState();
    filterList.add(SingleFilterModel(1, 'لايف الان', Icons.videocam));
    filterList.add(SingleFilterModel(2, 'مصر', Icons.flag));
    filterList.add(SingleFilterModel(3, 'السعودية', Icons.flag));
    filterList.add(SingleFilterModel(4, 'الاكثر مشاهدة', Icons.remove_red_eye));
    filterList.add(SingleFilterModel(5, 'الكل', Icons.border_all));
  }

  //  GlobalKey futureKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Echo('width $width');
    return Column(
      children: [
        HomeSlider(),
//        Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: Text(YemString().trending),
//        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...filterList.map((e) {
                return singleHomeFilterWidget(e);
              }).toList(),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: FutureBuilder<MainProviderModel>(
//          key: GlobalKey(),
            future: networkMainData(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  // child: Column(
                  //   children: [
                  //     if (snapshot.data.categories != null || snapshot.data.categories.length > 0)
                  //       HomeCategories(categories: snapshot.data.categories
                  //       ),
                  //   ],
                  // ),
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
//        return HomePageShimmer();
            },
          ),
        ),
      ],
    );
  }

  Widget singleHomeFilterWidget(SingleFilterModel model) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilterModelId = model.id;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12,horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: selectedFilterModelId == model.id ? AppColors().primaryColor() : Colors.grey[300],
            boxShadow: [
              BoxShadow(color: Colors.grey),
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 2),
          child: Text(
            model.title,
            style: TextStyle(color: selectedFilterModelId == model.id ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

class SingleFilterModel {
  int id;
  String title;
  IconData icon;

  SingleFilterModel(this.id, this.title, this.icon);
}
