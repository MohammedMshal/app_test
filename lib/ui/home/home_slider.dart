// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';

var _currentPage = 0;

class HomeSlider extends StatefulWidget {
  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  List<String> sliderList = List();

  @override
  void initState() {
    super.initState();
    sliderList.add("assets/img/bk_slider_1");
    sliderList.add("assets/img/bk_slider_2");
    sliderList.add("assets/img/bk_slider_3");
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;
    String locale = context.locale.toString();
    return Container(
//      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      color: Colors.grey[200],
      child: 
     // Stack(
           
          CarouselSlider(
            items: sliderList.map((singleSlider) {
              return 
              Stack(
                // children: <Widget>[
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(4),
                  //     child: Image.asset(
                  //       '$singleSlider.png',
                  //       fit: BoxFit.fitHeight,
                  //       height: 165,
                  //     ),
                  //   ),
                  // ),
                
              );
            }).toList(),
            options: CarouselOptions(
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 650),
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1.0,
              // to see it like cards
              initialPage: _currentPage,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              height: 165,
              onPageChanged: (pageNo, reason) {
                setState(() {
                  _currentPage = pageNo;
                });
              },
            ),
          ));
    //       SliderIndicators(widget: widget),
    //   ]
    //   ),
    // );
  }
}

class SliderIndicators extends StatelessWidget {
  const SliderIndicators({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final HomeSlider widget;

  @override
  Widget build(BuildContext context) {
    List<String> sliderList = List();
    sliderList.add('1');
    sliderList.add('2');
    sliderList.add('3');

    return Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...sliderList.map((singleString) {
              var index = sliderList.indexOf(singleString);
              return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppColors().primaryColor()
                          : Colors.white));
            }),
          ],
        ));
  }
}
