// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:kokylive/models/main_provider_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YemenyPrefs {
  /// **********    customerLang     ****************/
  setLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language') == null ? 'ar' : prefs.getString('language');
  }

  /// **********    FirstTimeVisit     ****************/
  setFirstTimeVisit(bool firstTimeVisit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstTimeVisit', firstTimeVisit);
  }

  Future<bool> getFirstTimeVisit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('firstTimeVisit') == null ? true : prefs.getBool('firstTimeVisit');
  }

  /// **********    Skip     ****************/
  setSkipAuth(bool skipAuth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('skipAuth', skipAuth);
  }

  Future<bool> getSkipAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('skipAuth') == null ? false : prefs.getBool('skipAuth');
  }

  /// **********   Customer Id     ****************/
  setUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  /// **********   Customer Phone     ****************/
  setPhone(String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phone);
  }

  Future<String> getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  /// **********   Customer token     ****************/
  setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// **********   Customer Country     ****************/
  setCountry(String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('country', country);
  }

  Future<String> getCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('country');
  }

  /// **********   Customer name     ****************/
  setFirstName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', name);
  }

  Future<String> getFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('first_name');
  }
  /// **********   Customer image     ****************/
  setImage(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('image', name);
  }

  Future<String> getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('image');
  }

  /// **********   Customer Email     ****************/
  setEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  /// **********   Show GridView     ****************/
  setShowGridView(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('gridView', status);
  }

  Future<bool> getShowGridView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('gridView') == null ? true : prefs.getBool('gridView');
  }

  void logout(BuildContext context) async {
    MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
    mainProviderModel = null;
    await setSkipAuth(null);
    await setFirstTimeVisit(null);
    await setUserId(null);
    await setPhone(null);
    await setToken(null);
    await setEmail(null);
    await setCountry(null);
    await setFirstName(null);
  }
}
