import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/models/cart_model_provider.dart';
import 'package:provider/provider.dart';

class HomeBottomAppBar extends StatefulWidget {
  final currentIndex;
  final updateCurrentIndex;

  HomeBottomAppBar({this.currentIndex, this.updateCurrentIndex});

  @override
  _HomeBottomAppBarState createState() => _HomeBottomAppBarState();
}

class _HomeBottomAppBarState extends State<HomeBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    double totalCartAmount = 0;
    int cartLength = 0;
    var cartModelProvider = Provider.of<CartModelProvider>(context);
    cartModelProvider.cartModel.map((singleCartItem) {
      totalCartAmount += (singleCartItem.price * singleCartItem.quantity);
      cartLength += singleCartItem.quantity;
    }).toList();

    return BottomAppBar(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: CircularNotchedRectangle(),
      child: buildBottomNavigationBar(cartLength),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(int cartLength) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      fixedColor: Colors.white,
//      backgroundColor: AppColors().primaryColor(),
      unselectedItemColor: Colors.grey,
      onTap: widget.updateCurrentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          activeIcon: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: Container(
                color: AppColors().accentColor(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.home,
                    size: 26,
                  ),
                )),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          activeIcon: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: Container(
                color: AppColors().accentColor(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    size: 26,
                  ),
                )),
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: Container(
                color: AppColors().accentColor(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.favorite_border,
                    size: 26,
                  ),
                )),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: Container(
                color: AppColors().accentColor(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.perm_identity,
                    size: 26,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
