import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/elements/server_error.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/models/route_argument.dart';
import 'package:kokylive/network_models/response_membership_stickers.dart';
import 'package:kokylive/repository/membership_sticker_response.dart';
import 'package:kokylive/ui/vip/vip_checkout_controller.dart';

class VipController extends StatelessWidget {
  static const id = 'vipcontroller';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors().primaryColor(),
        appBar: AppBar(
          title: Text(YemString().goVip,style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        body:  FutureBuilder<List<MembershipSticker>>(
          future: networkMembershipSticker(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if (snapshot.data.length > 0) {
                return Column(
                  children: [
                    SizedBox(height: 20),
                    ...snapshot.data.map((singleItem) {
                      return GestureDetector(
                        onTap: () async {
                          RouteArgument args = new RouteArgument(id:'${singleItem.id}' ,param: singleItem );
                          Navigator.of(context).pushNamed(VipCheckoutController.id,arguments:args );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                          decoration: BoxDecoration(
                              color: Color(0xFFE338F4),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey, width: 0.2)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CachedNetworkImage(
                                  width: 70,
                                  height: 70,
                                  imageUrl: singleItem.image.isNotEmpty?singleItem.image:'',
                                  errorWidget: (context, url, error) {
                                    return CircularProgressIndicator();
                                  },
                                  placeholder: (context, url) {
                                    return CircularProgressIndicator();
                                  },
                                ),

                                Text('${singleItem.cost} coin',style: TextStyle(fontSize: 18,color: Colors.white),),
                                Icon(Icons.arrow_forward_ios,color: Colors.white,),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              }else if(snapshot.hasError){
                return Center(child: Column(
                  children: [
                    ServerErrorWidget(),
                    Text('${snapshot.error.toString()}')
                  ],
                ),);
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            } else  {
              return Center(child: CircularProgressIndicator(),);
            }

          },
        )
      ),
    );
  }
}
