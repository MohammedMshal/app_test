

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kokylive/models/cart_model_provider.dart';

import 'package:kokylive/models/main_provider_model.dart';
import 'package:kokylive/ui/splash/splash_controller.dart';

import 'package:provider/provider.dart';
import 'helper/app_config.dart';
import 'models/product_provider_model.dart';
import 'models/products_provider_model.dart';
import 'route_generator.dart';

void main() {
//  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        // <-- change patch to your
        fallbackLocale: Locale('ar'),
        startLocale: Locale('ar'),
        useOnlyLangCode: true,
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColors().primaryColor()));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainProviderModel()),
        ChangeNotifierProvider(create: (context) => ProductsProviderModel()),
        ChangeNotifierProvider(create: (context) => ProductProviderModel()),
        ChangeNotifierProvider(create: (context) => CartModelProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        initialRoute: SplashController.id,
        onGenerateRoute: RouteGenerator.generateRoute,
//      debugShowMaterialGrid: true,
//      showSemanticsDebugger: true,

        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              elevation: 0, foregroundColor: Colors.white),
          brightness: Brightness.light,
          accentColor: AppColors().accentColor(),
//          dividerColor: AppColors().accentColor(0.1),
//          focusColor: AppColors().accentColor(1),
//          hintColor: AppColors().secondColor(1),
          primarySwatch: Colors.deepPurple,
          textTheme: GoogleFonts.cairoTextTheme(
            Theme.of(context).textTheme,
          ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(secondary: AppColors().accentColor()),
        ),
      ),
    );
  }
}
