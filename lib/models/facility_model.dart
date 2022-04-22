import 'package:flutter/foundation.dart';

class Facility with ChangeNotifier {
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
}
