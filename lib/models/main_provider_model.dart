
import 'package:flutter/foundation.dart';
import 'package:kokylive/network_models/response_main_data.dart' as cate;
import 'package:kokylive/network_models/response_profile.dart';
import 'package:kokylive/network_models/response_stickers.dart';

class MainProviderModel with ChangeNotifier {
  List<cate.Category> _categories;
  ProfileData _profileData;
  List<Sticker> _stickers;

  ProfileData get profileData => _profileData;

  set profileData(ProfileData value) {
    _profileData = value;
    notifyListeners();
  }

  List<cate.Category> get categories => _categories;

  set categories(List<cate.Category> value) {
    _categories = value;
    notifyListeners();
  }

  List<Sticker> get stickers => _stickers;

  set stickers(List<Sticker> value) {
    _stickers = value;
    notifyListeners();
  }


}
