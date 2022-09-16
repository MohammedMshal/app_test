import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePageShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Widget> widgetList = List();
    for (int i = 0; i < 5; i++) {
      widgetList.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: 50,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 15, width: (width - 82) * 0.8, color: Colors.grey),
                SizedBox(
                  height: 8,
                ),
                Container(height: 15, width: width / 3, color: Colors.grey),
              ],
            ),
          )
        ],
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Container(
                color: Colors.grey,
                width: double.infinity,
                height: 135,
              ),

              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: double.infinity,
                      height: 80,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: double.infinity,
                      height: 80,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: double.infinity,
                      height: 80,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: double.infinity,
                      height: 80,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: double.infinity,
                      height: 80,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: double.infinity,
                      height: 80,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: double.infinity,
                      height: 80,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: double.infinity,
                      height: 80,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: double.infinity,
                      height: 80,
                    ),
                  ),
                ],
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width:200,
                      height: 120,
                    ),
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 200,
                      height: 120,
                    ),

                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

class VerticalProductsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Widget> widgetList = List();
    for (int i = 0; i < 5; i++) {
      widgetList.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: 50,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 15, width: (width - 82) * 0.8, color: Colors.grey),
                SizedBox(
                  height: 8,
                ),
                Container(height: 15, width: width / 3, color: Colors.grey),
              ],
            ),
          )
        ],
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ...widgetList.map((singleList) {
                return singleList;
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class SingleProductShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Container(
                color: Colors.grey,
                width: double.infinity,
                height: 120,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 120,
                      height: 25,
                    ),
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 150,
                      height: 25,
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 120,
                      height: 25,
                    ),
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 150,
                      height: 25,
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 120,
                      height: 25,
                    ),
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 150,
                      height: 25,
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 120,
                      height: 25,
                    ),
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 150,
                      height: 25,
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 120,
                      height: 25,
                    ),
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 150,
                      height: 25,
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 120,
                      height: 25,
                    ),
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 150,
                      height: 25,
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 120,
                      height: 25,
                    ),
                    Container(
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                      width: 150,
                      height: 25,
                    ),
                  ],
                ),
              ),
              Divider(),



            ],
          ),
        ),
      ),
    );
  }
}
