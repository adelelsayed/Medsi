import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:medsi/models/storage_utils.dart';

class Facility {
  String name = "";
  String authenticationurl = "";
  String medrequesturl = "";
  String patientidurl = "";
  String patientidentifier = "";

  Facility(String pname, String pauthenticationurl, String pmedrequesturl,
      String ppatientidurl, String ppatientidentifier) {
    this.authenticationurl = pauthenticationurl;
    this.medrequesturl = pmedrequesturl;
    this.name = pname;
    this.patientidentifier = ppatientidentifier;
    this.patientidurl = ppatientidurl;
  }

  static Future<bool> facilityStillExists(String targetName) async {
    bool retVal = true;
    await medsiStorage.read(key: "Facilities").then((rawFacilites) {
      List<dynamic> parsedFacilities = rawFacilites.toString() != "null"
          ? json.decode(rawFacilites.toString())
          : [];

      parsedFacilities.firstWhere(
        (element) => element["name"] == targetName,
        orElse: () => retVal = false,
      );

      return retVal;
    });
    return retVal;
  }
}
