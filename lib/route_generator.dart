import 'package:flutter/material.dart';
import 'package:kokylive/elements/photo_view_zoom.dart';
import 'package:kokylive/ui/coins/coins_controller.dart';
import 'package:kokylive/ui/payment/payment_controller.dart';
import 'package:kokylive/ui/profile/profile_screen.dart';
import 'package:kokylive/ui/vip/vipController.dart';
import 'package:kokylive/ui/withdrawals/my_withdrawals_controller.dart';

import 'ui/about_policy/about_controller.dart';
import 'ui/about_policy/policy_controller.dart';
import 'ui/account/account_controller.dart';
import 'ui/coins/coins_checkout_controller.dart';
import 'ui/contact_us/contact_us_controller.dart';
import 'ui/home/home_controller.dart';
import 'ui/lang/select_lang.dart';
import 'ui/login/login_page.dart';
import 'ui/onboard/on_boarding_page.dart';
import 'ui/orders/orders_controller.dart';
import 'ui/product/product_controller.dart';
import 'ui/products/products_controller.dart';
import 'ui/register/register_controller.dart';
import 'ui/search/search_controller.dart';
import 'ui/search/search_result.dart';
import 'ui/search/search_text_controller.dart';
import 'ui/splash/splash_controller.dart';
import 'ui/user_profile/user_profile_controller.dart';
import 'ui/vip/vip_checkout_controller.dart';
import 'ui/withdrawals/withdraw_controller.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case RegisterController.id:
        return MaterialPageRoute(builder: (_) => RegisterController());
        break;
      case AboutController.id:
        return MaterialPageRoute(builder: (_) => AboutController());
        break;
      case PolicyController.id:
        return MaterialPageRoute(builder: (_) => PolicyController());
        break;
      case LoginController.id:
        return MaterialPageRoute(builder: (_) => LoginController());
        break;
      case SplashController.id:
        return MaterialPageRoute(builder: (_) => SplashController());
        break;
      case ContactUs.id:
        return MaterialPageRoute(builder: (_) => ContactUs());
        break;
      case SearchResult.id:
        return MaterialPageRoute(builder: (_) => SearchResult());
        break;
      case VipController.id:
        return MaterialPageRoute(builder: (_) => VipController());
        break;
      case OrdersController.id:
        return MaterialPageRoute(builder: (_) => OrdersController());
        break;
      case MyWithdrawalsController.id:
        return MaterialPageRoute(builder: (_) => MyWithdrawalsController());
        break;
      case WithdrawalController.id:
        return MaterialPageRoute(builder: (_) => WithdrawalController());
        break;
      case UserProfileController.id:
        return MaterialPageRoute(
            builder: (_) => UserProfileController(
                  args: args,
                ));
        break;
      case PhotoViewWidget.id:
        return MaterialPageRoute(
            builder: (_) => PhotoViewWidget(
                  argument: args,
                ));
        break;
      case VipCheckoutController.id:
        return MaterialPageRoute(
            builder: (_) => VipCheckoutController(
                  args: args,
                ));
        break;
      case PaymentController.id:
        return MaterialPageRoute(builder: (_) => PaymentController());
        break;
      case ProfileScreen.id:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
        break;
      case AccountController.id:
        return MaterialPageRoute(builder: (_) => AccountController());
        break;
      // case VideoLive.id:
      //   return MaterialPageRoute(builder: (_) => VideoLive());
      //   break;
      // case VideoView.id:
      //   return MaterialPageRoute(builder: (_) => VideoView());
      //   break;
      case CoinsCheckoutController.id:
        return MaterialPageRoute(
            builder: (_) => CoinsCheckoutController(
                  args: args,
                ));
        break;
      case CoinsController.id:
        return MaterialPageRoute(builder: (_) => CoinsController());
        break;
      case SearchTextController.id:
        return MaterialPageRoute(builder: (_) => SearchTextController());
        break;

      case SearchController.id:
        return MaterialPageRoute(builder: (_) => SearchController());
        break;

      case HomeController.id:
        return MaterialPageRoute(builder: (_) => HomeController());
        break;

      case ProductController.id:
        return MaterialPageRoute(
            builder: (_) => ProductController(
                  args: args,
                ));
        break;

      case ProductsController.id:
        return MaterialPageRoute(
            builder: (_) => ProductsController(args: args));
        break;
      case OnBoardingPage.id:
        return MaterialPageRoute(builder: (_) => OnBoardingPage());
        break;
      case SelectLangController.id:
        return MaterialPageRoute(builder: (_) => SelectLangController());
        break;
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: SafeArea(child: Text('Route Error ${settings.name}'))));
    }
  }
}
