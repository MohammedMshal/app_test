import 'package:flutter/material.dart';

class AppColors {
  Color primaryColor({double opacity = 1}) {
    return Color(0xFF9B2CF5).withOpacity(opacity);
  }

  Color primaryDarkColor({double opacity = 1}) {
    return Color(0xFF6D27E9).withOpacity(opacity);
  }
  Color primaryLightColor({double opacity = 1}) {
    return Color(0xFFE338F4).withOpacity(opacity);
  }

  Color accentColor({double opacity = 1}) {
    return Color(0xFF1E003E).withOpacity(opacity);
  }


}
class AppStrings {
  static const String PLAY_STORE = '';
  static const String APP_STORE = '';
  static const double CURRENCY_USD_SAR = 0.27;
  static const  String AGORA_ID = '9d724295e5004e258ba080252646702b';

}
