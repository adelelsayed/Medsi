import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:developer';

import '../models/storage_utils.dart';
import 'package:medsi/models/facility_model.dart';

class FacilitiesProvider with ChangeNotifier {
  List<Facility> facilities = [];

  Future<void> getFacilites() async {
    medsiStorage.read(key: "Facilities").then((rawFacilites) {
      List<dynamic> parsedFacilities = json.decode(rawFacilites.toString());
      parsedFacilities.forEach((rawFacility) {
        Facility currentFacility = Facility(
            rawFacility["name"],
            rawFacility["authenticationurl"],
            rawFacility["medrequesturl"],
            rawFacility["patientidurl"],
            rawFacility["patientidentifier"]);

        facilities.add(currentFacility);
        notifyListeners();
      });
    });
  }
}
