import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiry;
  String _userId;
  Timer _authTimer;

  bool get isAuthenticated {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiry != null && _expiry.isAfter(DateTime.now()) && _token != null)
      return _token;
    return null;
  }

  Future<void> signup(String email, String password) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDzprOtaVeauyx5FfXQ4aV-1IwlOO8CTwc";
    try {
      final res = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(res.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiry = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        'userId': _userId,
        'expiry': _expiry.toIso8601String()
      });
      prefs.setString("userData", userData);
      _autoLogout();
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> login(String email, String password) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDzprOtaVeauyx5FfXQ4aV-1IwlOO8CTwc";
    try {
      final res = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(res.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiry = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        'userId': _userId,
        'expiry': _expiry.toIso8601String(),
      });
      prefs.setString("userData", userData);
      _autoLogout();
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
  Future<bool> tryLoginAuto() async {
    final prefs=await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData'))
      return false;
    final data=json.decode(prefs.getString("userData")) as Map<String,Object>;
    if(DateTime.parse(data['expiry']).isBefore(DateTime.now()))
      return false;
    _token=data["token"];
    _userId=data["userId"];
    _expiry=DateTime.parse(data["expiry"]);
    notifyListeners();
    _autoLogout();
    return true;

  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiry = null;
    
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs=await SharedPreferences.getInstance();
    prefs.remove("userData");


    
  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer.cancel();
    final timeExpire = _expiry.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeExpire), logout);
  }
}
