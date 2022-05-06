import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:developer';

import '../models/storage_utils.dart';
import 'package:medsi/models/facility_model.dart';
import 'package:medsi/tasks/medication_list_fetch_process.dart';

class FacilitiesProvider with ChangeNotifier {
  List<Facility> facilities = [];

  Future<void> getFacilites() async {
    medsiStorage.read(key: "Facilities").then((rawFacilites) {
      if (rawFacilites.toString() == "null") {
        return;
      }

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

  Future<void> setFacilites(
      Facility oldFacilityObjToUpdate, Facility newFacilityObjToUpdate) async {
    medsiStorage.read(key: "Facilities").then((rawFacilites) {
      List<dynamic> parsedFacilities = rawFacilites.toString() != "null"
          ? json.decode(rawFacilites.toString())
          : [];
      bool foundChange = false;
      bool doCopy = false;
      int targetIdx = 0;
      dynamic newFacility;

      if (parsedFacilities.isNotEmpty) {
        for (dynamic rawFacility in parsedFacilities) {
          targetIdx = parsedFacilities.indexOf(rawFacility);
          if ((oldFacilityObjToUpdate.name != "") &&
              (rawFacility["name"] == oldFacilityObjToUpdate.name)) {
            foundChange = true;
            doCopy = true;
          } else {
            doCopy = true;
          }
          if (foundChange) {
            break;
          }
        }
      } else {
        doCopy = true;
      }

      if (doCopy) {
        newFacility = {
          "name": newFacilityObjToUpdate.name,
          "authenticationurl": newFacilityObjToUpdate.authenticationurl,
          "medrequesturl": newFacilityObjToUpdate.medrequesturl,
          "patientidurl": newFacilityObjToUpdate.patientidurl,
          "patientidentifier": newFacilityObjToUpdate.patientidentifier
        };

        parsedFacilities.isNotEmpty
            ? parsedFacilities
                .replaceRange(targetIdx, targetIdx + 1, [newFacility])
            : parsedFacilities.add(newFacility);
      }

      medsiStorage
          .write(key: "Facilities", value: json.encode(parsedFacilities))
          .then((value) {
        this.facilities.remove(oldFacilityObjToUpdate);
        MedicationListProcess.getPatientId(newFacility["patientidurl"],
                newFacility["patientidentifier"], newFacility["name"])
            .then((value) {
          notifyListeners();
          getFacilites();
        });
      });
    });
  }

  Future<void> delete(Facility facilityToDelete) async {
    medsiStorage.read(key: "Facilities").then((rawFacilites) {
      List<dynamic> parsedFacilities = rawFacilites.toString() != "null"
          ? json.decode(rawFacilites.toString())
          : [];
      log(parsedFacilities.toString());
      if (parsedFacilities.isNotEmpty) {
        parsedFacilities
            .removeWhere((element) => element["name"] == facilityToDelete.name);
      }
      log(parsedFacilities.toString());
      medsiStorage
          .write(key: "Facilities", value: json.encode(parsedFacilities))
          .then((value) {
        this.facilities.remove(facilityToDelete);
        notifyListeners();
      });
    });
  }
}
