import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:device_information/device_information.dart';

import '../http_utils/http_funs.dart';
import '../models/storage_utils.dart';
import '../models/facility_model.dart';

class Auth with ChangeNotifier {
  String userName = "";
  String passWord = "";
  Map<String, String> _token = {};
  late DateTime _expiryDate;
  late String _userId;
  late Timer _authTimer;
  Map<String, String> authErrors = {};
  bool _isAuth = false;
  String registerationState = "Logon";

  bool get isAuth {
    return _isAuth;
  }

  void set isAuth(bool val) {
    _isAuth = val;
  }

  Auth() {
    getRegisterationState();
  }

  Future<void> getRegisterationState() async {
    await medsiStorage.read(key: "Credentials").then((value) {
      if (value.toString() == 'null') {
        registerationState = "Register";
        notifyListeners();
      }
    });
  }

  Future<void> writeCredentials(String userName, String passWord, String email,
      String phoneNumber) async {
    List<dynamic> credentials = [userName, passWord, email, phoneNumber];
    medsiStorage.write(key: "Credentials", value: json.encode(credentials));
  }

  bool isAuthByFacility(facilityname) {
    return token.isNotEmpty &&
        token.containsKey(facilityname + "CurrentAuthToken");
  }

  Map<String, String> get token {
    return _token;
  }

  String get userId {
    return _userId;
  }

  void set token(tokenMap) {
    _token = tokenMap;
  }

  void setTokenByFacility(facilityname, tokenText) {
    this.token.update(facilityname + "CurrentAuthToken", (value) => tokenText,
        ifAbsent: () => tokenText);
    isAuth = true;
    notifyListeners();
  }

  bool authenticateLocal(String user, String pass) {
    this.isAuth = (user == this.userName) && (pass == this.passWord);

    return this.isAuth;
  }

  static Future<dynamic> getListOfFacilities() async {
    dynamic rawFacilities = await medsiStorage.read(key: "Facilities");
    return rawFacilities;
  }

  static Future<dynamic> getCredentials() async {
    dynamic credentials = await medsiStorage.read(key: "Credentials");
    return credentials;
  }

  void setCredentials() async {
    Auth.getCredentials().then((credMap) {
      List<dynamic> credMapD = json.decode(credMap.toString());

      if (credMapD.toString() != 'null') {
        this.userName = credMapD[0];
        this.passWord = credMapD[1];
      }
    });
  }

  static Future<String> getDeviceImei() async {
    String deviceNameI = await DeviceInformation.deviceName;
    //log(deviceNameI.toString());
    return deviceNameI;
  }
}
