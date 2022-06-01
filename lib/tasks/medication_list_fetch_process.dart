import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:medsi/http_utils/http_funs.dart';
import 'package:medsi/models/storage_utils.dart';
import 'package:medsi/provider_utils/auth_provider.dart';
import 'package:medsi/utils/fhir_parser.dart';
import 'package:medsi/utils/fhir_to_medsi_converter.dart';

class MedicationListProcess {
  static Future<int> getintervalMinutes() async {
    int retVal = 0;
    await medsiStorage
        .read(key: "MedicationListProcess_intervalMinutes")
        .then((value) {
      retVal = value != null ? int.parse(value) : 5;
    });
    return retVal;
  }

  static Future<void> getPatientId(
      String patientUrl, String patientIdentifier, String facilityKey) async {
    try {
      medsiStorage.read(key: "Facilities").then((Facilitiesvalue) {
        List<dynamic> FacilitiesMap =
            List<dynamic>.from(json.decode(Facilitiesvalue.toString()));
        Map<String, dynamic> currentFacility = FacilitiesMap.firstWhere(
            (element) =>
                Map<String, dynamic>.from(element)["name"] == facilityKey);

        MedsiHttp patientRequest = MedsiHttp(
            Uri.parse(patientUrl + patientIdentifier),
            {"Token": currentFacility["Token"]}, (ajaxResponse1) {
          if (ajaxResponse1.statusCode == 200) {
            Map<String, dynamic> patDataMap = json.decode(ajaxResponse1.body);
            FHIRBundle patientBundle = FHIRBundle(patDataMap);
            patientBundle.validate().then((val) {
              if ((patientBundle.isvalid) &&
                  (List.from(patDataMap["entry"]).length == 1)) {
                FHIRPatientRequest PatientRequest =
                    FHIRPatientRequest(patDataMap["entry"][0]);
                PatientRequest.validate().then((value) {
                  if (PatientRequest.isvalid) {
                    String patientId = patDataMap["entry"][0]["resource"]["id"];

                    currentFacility["patientId"] = patientId;
                    FacilitiesMap.removeWhere((element) =>
                        Map<String, dynamic>.from(element)["name"] ==
                        facilityKey);
                    FacilitiesMap.add(currentFacility);

                    medsiStorage.write(
                        key: "Facilities", value: json.encode(FacilitiesMap));
                  } else {
                    log(PatientRequest.ErrorMessage.toString());
                  }
                });
              } else {
                log(patientBundle.ErrorMessage.toString());
              }
            });
          } else {
            log(ajaxResponse1.statusCode.toString());
            log("error fetching patient id");
          }
        });
        patientRequest.get();
      });
    } catch (e) {}
  }

  static Future<void> processMedsLoop(
      dynamic dataMapEntry, String facilityName) async {
    //stub
    dataMapEntry["resource"]["extension"] = {
      "durationCode": "d",
      "durationNumber": 100,
      "prescriptionNo": "px",
      "ImageURL":
          "https://img.medscapestatic.com/pi/features/drugdirectory/octupdate/CIP01420.jpg"
    };

    FHIRMedRequest MedReqValidationObj = FHIRMedRequest(dataMapEntry);
    MedReqValidationObj.validate().then((value) {
      if (MedReqValidationObj.isvalid) {
        //convert to medsi internal scheme
        //write to storage

        medsiStorage.read(key: "MedsList").then((currentListMapMedsRaw) {
          Map<String, dynamic> currentListMapMeds =
              json.decode(currentListMapMedsRaw.toString());

          FHIRToMedsiConverter converter =
              FHIRToMedsiConverter(fhirMap: dataMapEntry["resource"]);
          converter.convert();

          currentListMapMeds[facilityName]["MedsList"][converter.currentMedId] =
              converter.medsiMap;

          medsiStorage.write(
              key: "MedsList", value: json.encode(currentListMapMeds));
        });
      } else {
        log(MedReqValidationObj.ErrorMessage.toString());
      }
    });
  }

  static Future<void> getMedsListOnce() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Auth.getListOfFacilities().then((facilitiesObj) {
      if (facilitiesObj != null) {
        var Facilities = json.decode(facilitiesObj.toString());
        Map<String, Object> totalDataMap = {};

        for (var facility in Facilities) {
          MedsiHttp medRequest = MedsiHttp(
              Uri.parse(facility["medrequesturl"].toString() +
                  facility["patientId"].toString()),
              {"Token": facility["Token"]}, (ajaxResponse) {
            if (ajaxResponse.statusCode == 200) {
              Map<String, dynamic> dataMap = json.decode(ajaxResponse.body);
              Map<String, dynamic> convertedDataMap = {};
              List<Map<String, dynamic>> convertedMedList = [];
              // if  isValid(dataMap)

              FHIRBundle inputBundle = FHIRBundle(dataMap);

              medsiStorage.read(key: "MedsList").then((currentListMapRaw) {
                Map<String, dynamic> currentListMap =
                    ((currentListMapRaw != null) &&
                            (currentListMapRaw.isNotEmpty))
                        ? json.decode(currentListMapRaw.toString())
                        : {};

                inputBundle.validate().then((value) {
                  if (inputBundle.isvalid) {
                    //delete old record

                    currentListMap[facility["name"]] = {};

                    currentListMap[facility["name"]]["Facility"] =
                        facility["name"];
                    currentListMap[facility["name"]]["TimeOfQuery"] =
                        DateTime.now().toString();
                    currentListMap[facility["name"]]["MedsList"] = {};

                    medsiStorage
                        .write(
                            key: "MedsList", value: json.encode(currentListMap))
                        .then((value) {
                      for (var MedReq in dataMap["entry"]) {
                        processMedsLoop(MedReq, facility["name"]);
                      }
                    });
                  } else {
                    log(inputBundle.ErrorMessage.toString());
                  }
                });
              });
            } else {
              log(ajaxResponse.statusCode.toString());
            }
          });

          medRequest.timeOutFunction = () {
            log("timeoutmessage");
          };

          medRequest.get();
        }
      }
    });
  }
}
